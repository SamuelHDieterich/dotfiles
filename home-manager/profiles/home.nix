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

  services.udiskie.enable = true;

  home.file = {};

  home.sessionVariables = {
    EDITOR = lib.getExe pkgs.neovim;
    VISUAL = lib.getExe pkgs.vscode;
    MANPAGER = lib.getExe pkgs.bat;
    XCURSOR_THEME = config.gtk.cursorTheme.name;
    XCURSOR_SIZE = config.gtk.cursorTheme.size;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Check the documentation before changing this.
  home.stateVersion = "24.05";
}
