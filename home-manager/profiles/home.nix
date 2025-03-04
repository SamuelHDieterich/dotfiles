{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/base.nix
    ../modules/shell/zsh.nix
    ../modules/shell/starship.nix
    ../modules/terminal/kitty.nix
    ../modules/dev/git.nix
    # ../modules/dev/vscode.nix
    ../modules/wm/hyprland/hyprland.nix
  ];

  # Base configuration
  base = {
    username = "samuel";
    allowUnfree = true;
  };

  xdg.enable = true;
  gtk = {
    enable = true;
    theme = {
      package = pkgs.juno-theme;
      name = "Juno-ocean";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
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
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/Sweet".source = "${pkgs.sweet-nova}/share/Kvantum/Sweet";
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Sweet
    '';
  };

  home.packages = with pkgs; [
    # Editor
    vscode
    # Browser
    firefox
    qbittorrent
    # Office
    libreoffice
    zathura
    thunderbird
    obsidian
    google-fonts
    # Media
    mpv
    vlc
    imv
    spotify
    # Graphics
    inkscape
    gimp
    obs-studio
    # File Manager
    yazi
    xfce.thunar
    xfce.thunar-archive-plugin
    # Password Manager
    keepassxc
    # Utilities
    tlrc
    ripgrep
    btop
    powertop
    mission-center
    p7zip
    pavucontrol
    jq
    yq
    nvtopPackages.full
    swappy
    syncthing
    # Misc
    fastfetch
  ];

  services.udiskie.enable = true;

  home.sessionVariables = {
    EDITOR = lib.getExe pkgs.neovim;
    VISUAL = lib.getExe pkgs.vscode;
    MANPAGER = lib.getExe pkgs.bat;
    XCURSOR_THEME = config.gtk.cursorTheme.name;
    XCURSOR_SIZE = config.gtk.cursorTheme.size;
  };
}
