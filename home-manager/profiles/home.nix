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
    theme = {
      package = pkgs.juno-theme;
      name = "Juno-ocean";
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela";
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
    spotify
    keepassxc
    vscode
    tlrc
    ripgrep
    fastfetch
    powertop
    yazi
    p7zip
    firefox
    thunderbird
    btop
    pavucontrol
    eza
    zathura
    wl-clipboard
    jq
    yq
    vlc
    mpv
    inkscape
    gimp
    obs-studio
    libreoffice
    nvtopPackages.full
    mission-center
    bat
    nh
    grim
    slurp
    swappy
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
