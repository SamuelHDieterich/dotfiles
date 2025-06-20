{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/base.nix
    ../modules/shell/zsh.nix
    ../modules/shell/starship.nix
    ../modules/terminal/kitty.nix
    ../modules/dev/git.nix
    ../modules/utilities/rofi.nix
  ];

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

  home.packages = with pkgs; [
    # Editor
    # vscode
    # Browser
    # firefox
    # Development
    kubectl
    kubernetes-helm
    terraform
    opentofu
    terragrunt
    postman
    # Office
    # libreoffice
    # # zathura
    # # thunderbird
    # # Media
    # # mpv
    # # vlc
    # # imv
    spotify
    # Graphics
    inkscape
    gimp
    # obs-studio
    # # File Manager
    yazi
    # Password Manager
    # keepassxc
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
    # Misc
    fastfetch
    # Nix
    nh
    nil
    nixfmt-classic
  ];
  
  home.sessionVariables = {
    EDITOR = lib.getExe pkgs.neovim;
    VISUAL = lib.getExe pkgs.vscode;
    MANPAGER = lib.getExe pkgs.bat;
    XCURSOR_THEME = config.gtk.cursorTheme.name;
    XCURSOR_SIZE = config.gtk.cursorTheme.size;
  };
}