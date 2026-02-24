{ inputs, ... }:
let
  system = "x86_64-linux";
  stateVersion = "24.05";
  username = "samuel";
  hostname = "turing";
  bundles = [
    "development"
    "office"
    "fonts"
    "media"
    "graphics"
    "security"
    "utilities"
    "network"
    "nix"
  ];
in {
  flake.homeConfigurations.${hostname} =
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs; };
      modules = [
        inputs.self.homeModules.${hostname} # Base home configuration
        inputs.self.homeModules.nonNixos # Required for non-NixOS systems
        {
          # Packages
          ## If set in homeModules, the NixOS configuration would duplicate these packages.
          metapackages.bundles = bundles;
        }
        { home.stateVersion = stateVersion; } # Not recommended to change this
      ];
    };

  flake.homeModules.${hostname} = { config, lib, pkgs, ... }: {
    imports = with inputs.self.homeModules; [
      base # Base home configuration
      shell # Shell
      # Terminal
      tmux # Terminal multiplexer
      foot # Wayland terminal emulator
      # Development
      git # Git configuration
      virtmanager # virt-manager configuration
      # Utilities
      rofi # Application launcher and window switcher
    ];

    # Base configuration
    nixpkgs.config.allowUnfree = true;
    base = {
      username = username;
      stateVersion = stateVersion; # Not recommended to change this
    };

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
        "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
      };
    };

    # Programs
    programs.firefox = {
      enable = true;
      package = lib.mkIf config.targets.genericLinux.enable
        (config.lib.nixGL.wrap pkgs.firefox);
    };

    # Packages
    metapackages.bundles = bundles;
    home.packages = with pkgs; [
      # Editor
      vscode
      neovim
      # Development
      postman
    ];

    # Environment variables
    home.sessionVariables = {
      EDITOR = lib.getExe pkgs.neovim;
      VISUAL = lib.getExe pkgs.vscode;
      XCURSOR_THEME = config.gtk.cursorTheme.name;
      XCURSOR_SIZE = config.gtk.cursorTheme.size;
    };
  };
}
