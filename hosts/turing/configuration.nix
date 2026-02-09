{ inputs, ... }:
let
  system = "x86_64-linux";
in
{
  flake.homeConfigurations.turing = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    modules = [
      inputs.self.homeModules.turing
      { home.stateVersion = "24.05"; }
    ];
  };

  flake.homeModules.turing =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = with inputs.self.homeModules; [
        base
        # Shell modules
        zsh
        starship # Shell prompt
        # Terminal
        foot # Wayland terminal emulator
        # Development
        git # Git version control
        # Utilities
        rofi # Application launcher and window switcher
      ];

      # Base configuration
      nix.package = pkgs.nix; # Required for non-NixOS systems
      nixpkgs.config.allowUnfree = true;
      base = {
        username = "samuel";
        stateVersion = "24.05";
      };

      # This is a MUST for non NixOS systems
      targets.genericLinux.enable = true;
      programs.bash.enable = true;

      # Style
      xdg.enable = true;
      gtk = {
        enable = true;
        # theme = {
        #   package = pkgs.juno-theme;
        #   name = "Juno-ocean";
        # };
        # iconTheme = {
        #   package = pkgs.tela-icon-theme;
        #   name = "Tela";
        # };
        cursorTheme = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 20;
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
      };
      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };

      # NixGL for OpenGL support on non-NixOS systems
      targets.genericLinux.nixGL = {
        packages = inputs.nixgl.packages;
        defaultWrapper = "mesa";
        installScripts = [ "mesa" ];
        vulkan.enable = true;
      };

      # Programs
      programs.firefox = {
        enable = true;
        package = (config.lib.nixGL.wrap pkgs.firefox);
      };
      home.packages = with pkgs; [
        # Editor
        #vscode
        neovim
        # Browser
        # firefox
        # Development
        kubectl
        kubernetes-helm
        terraform
        opentofu
        terragrunt
        postman
        devenv
        direnv
        (google-cloud-sdk.withExtraComponents [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
        k9s
        # Office
        libreoffice
        zathura
        qalculate-gtk
        # # thunderbird
        # # Media
        mpv
        vlc
        # # imv
        spotify
        # Graphics
        inkscape
        gimp
        # obs-studio
        # # File Manager
        yazi
        # Password Manager
        keepassxc
        # Utilities
        tlrc
        ripgrep
        btop
        powertop
        mission-center
        p7zip
        jq
        jnv
        yq
        swappy
        bat
        # Misc
        fastfetch
        # Fonts
        nerd-fonts.jetbrains-mono
        caladea
        # Nix
        nh
        nil
        nixfmt-classic
      ];

      # Fonts
      fonts.fontconfig.enable = true;

      # Environment variables
      home.sessionVariables = {
        EDITOR = lib.getExe pkgs.neovim;
        VISUAL = lib.getExe pkgs.vscode;
        XCURSOR_THEME = config.gtk.cursorTheme.name;
        XCURSOR_SIZE = config.gtk.cursorTheme.size;
      };
    };
}
