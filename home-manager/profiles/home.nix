{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../modules/shell/zsh.nix
    ../modules/shell/starship.nix
    ../modules/terminal/kitty.nix
    ../modules/dev/git.nix
    ../modules/wm/hyprland/hyprland.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "samuel";
    homeDirectory = "/home/samuel";
  };

  xdg.enable = true;
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  qt = {
    enable = true;
  };

  home.packages = with pkgs; [
    spotify
    keepassxc
    vscode
    tldr
    ripgrep
    fastfetch
    powertop
    yazi
    p7zip
    firefox
    thunderbird
    btop
    emote
    pavucontrol
    eza
    zathura
    wl-clipboard
    jq
    yq
    vlc
    inkscape
    gimp
    libreoffice
    nvtopPackages.full
    zoxide
    #mission-center
    bat
    nh
  ];

  programs.zoxide.enable = true;

  #programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs; [
  #  # Add any missing dynamic libraries for unpackaged programs
  #  # here, NOT in environment.systemPackages
  #];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "code";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = 20;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Check the documentation before changing this.
  home.stateVersion = "24.05";
}
