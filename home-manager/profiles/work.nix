{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ../modules/base.nix
    ../modules/shell/zsh.nix
    ../modules/shell/starship.nix
    ../modules/terminal/kitty.nix
    ../modules/dev/git.nix
    # ../modules/dev/neovim.nix
    ../modules/utilities/rofi.nix
  ];

  # Required for non-NixOS systems
  nix.package = pkgs.nix;

  # Base configuration
  base = {
    username = "samuel";
    allowUnfree = true;
  };

  # This is a MUST for non NixOS systems
  targets.genericLinux.enable = true;
  programs.bash.enable = true;

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

  programs.firefox.enable = true;
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
    (google-cloud-sdk.withExtraComponents
      [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
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

  # NixGL for OpenGL support on non-NixOS systems
  targets.genericLinux.nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
    vulkan.enable = true;
  };
  programs = {
    firefox.package = (config.lib.nixGL.wrap pkgs.firefox);
    kitty.package = (config.lib.nixGL.wrap pkgs.kitty);
  };

  # Fonts
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = lib.getExe pkgs.neovim;
    VISUAL = lib.getExe pkgs.vscode;
    XCURSOR_THEME = config.gtk.cursorTheme.name;
    XCURSOR_SIZE = config.gtk.cursorTheme.size;
  };
}
