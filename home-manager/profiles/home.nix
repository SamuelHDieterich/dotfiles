{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/base.nix
    # Shell
    ../modules/shell/bash.nix
    ../modules/shell/zsh.nix
    ../modules/shell/fish.nix
    ../modules/shell/nushell.nix
    ../modules/shell/starship.nix
    # Terminal
    ../modules/terminal/tmux.nix
    ../modules/terminal/kitty.nix
    ../modules/terminal/foot.nix
    # Development
    ../modules/dev/git.nix
    # ../modules/dev/neovim.nix
    # ../modules/dev/vscode.nix
    ../modules/dev/virtmanager.nix
    # Desktop
    ../modules/wm/hyprland/hyprland.nix
    ../modules/utilities/waybar.nix
    ../modules/utilities/dunst.nix
  ];

  # Base configuration
  base = { username = "samuel"; };

  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
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
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
    };
  };
  # qt = {
  #   enable = true;
  #   platformTheme.name = "qtct";
  #   style.name = "kvantum";
  # };

  # xdg.configFile = {
  #   "Kvantum/Sweet".source = "${pkgs.sweet-nova}/share/Kvantum/Sweet";
  #   "Kvantum/kvantum.kvconfig".text = ''
  #     [General]
  #     theme=Sweet
  #   '';
  # };

  home.packages = with pkgs; [
    # Editor
    vscode # Visual Studio Code
    neovim # Vim-based text editor
    # Browser
    firefox # 🔥🦊
    brave # 🦁
    # Development
    python3 # Python programming language
    git # Version control
    lazygit # Git TUI
    jq # JSON processor
    yq # YAML processor
    jnv # jq TUI
    jless # JSON viewer
    difftastic # Structural diff tool
    docker # Container management
    docker-compose # Multi-docker management
    devenv # Development environment management
    # Office
    libreoffice # Office suite
    zathura # PDF viewer
    thunderbird # Email client
    obsidian # Note-taking app
    google-fonts # Google Fonts
    # Media
    mpv # Media player
    vlc # Media player
    imv # Image viewer
    spotify # Music streaming
    freetube # YouTube client
    # Graphics
    inkscape # Vector graphics editor
    gimp # Raster graphics editor
    obs-studio # Screen recording and streaming
    krita # Digital painting
    blender # 3D modeling and animation
    freecad # 3D CAD modeler
    # File Manager
    yazi # TUI
    xfce.thunar # GUI
    xfce.thunar-archive-plugin # Archive support for Thunar
    # Password Manager
    keepassxc
    # Utilities
    eza # Enhanced ls
    bat # Cat replacement
    bat-extras.core # Extras for bat
    glow # Markdown viewer
    tlrc # Straightforward helper
    ripgrep # Enhanced grep
    (btop.override { cudaSupport = true; }) # System monitor
    mission-center # System monitor
    powertop # Power consumption monitor
    p7zip # Archive manager
    pavucontrol # PulseAudio volume control
    nvtopPackages.full # NVIDIA GPU monitor
    swappy # Image editor
    syncthing # File synchronization
    dysk # Disk usage analyzer
    dua # Disk usage analyzer
    fselect # Query file system
    fd # Alternative to find
    # Misc
    fastfetch # System information tool
    qbittorrent # Torrent client
  ];

  services.udiskie.enable = true;

  home.sessionVariables = {
    EDITOR = lib.getExe pkgs.neovim;
    VISUAL = lib.getExe pkgs.vscode;
    MANPAGER = "env BATMAN_IS_BEING_MANPAGER=yes "
      + lib.getExe pkgs.bat-extras.batman;
  };
}
