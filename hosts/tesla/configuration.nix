{ inputs, lib, ... }:
let
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.tesla = inputs.nixpkgs.lib.nixosSystem {
    modules = with inputs.self; [
      nixosModules.tesla
      # homeConfigurations.tesla
      { nixpkgs.hostPlatform = lib.mkDefault system; }
    ];
  };

  flake.homeConfigurations.tesla = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    modules = [
      inputs.self.homeModules.tesla
      { home.stateVersion = "24.05"; }
    ];
  };

  flake.nixosModules.tesla =
    { config, pkgs, ... }:
    {
      # Add modules
      imports = with inputs.self.nixosModules; [
        # Operating System modules
        base # Base system configuration
        lanzaboote # Secure boot configuration
        # Hardware modules
        nvidia # Nvidia GPU support
        audio # Audio configuration
        time # Time synchronization
        power # Power management
        bluetooth # Bluetooth support
        # Display Manager modules
        greetd # Greetd display manager
        # Window Manager modules
        hyprland # Hyprland window manager
        # Development modules
        virtmanager # Virtual machine management with virt-manager
        tailscale # Tailscale VPN client
        # Misc modules
        printing # Printer and scanner support
        obs-studio # OBS Studio for screen recording and streaming
        thunar # Thunar file manager
        games # Games and emulators
      ];

      # Base configuration
      base = {
        hostname = "tesla";
        version = "24.05"; # Not recommended to change this
        username = "samuel";
        allowUnfree = true;
      };

      # Boot
      lanzaboote.kernelPackages = pkgs.linuxPackages;

      # Nvidia
      nvidia = {
        package = "latest";
        open = true;
        powerManagement = true;
        prime = {
          enable = true;
          renderOffload = true;
          busId = {
            nvidia = "PCI:1:0:0";
            intel = "PCI:0:2:0";
          };
        };
      };

      # Hardware
      hardware = {
        i2c.enable = true; # Enable I2C support
        brillo.enable = true; # Adjust screen brightness
      };

      # Keyring
      services.gnome.gnome-keyring.enable = true;
      programs.seahorse.enable = true;

      # Disks
      services.gvfs.enable = true;
      services.udisks2.enable = true;

      # Thumbnails
      services.tumbler.enable = true;

      # Fonts
      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
          caladea
        ];
      };

      # Programs
      programs.nix-index.enable = true; # Index nixpkgs for quick searching (includes shell integration).
      programs.nix-ld.enable = true; # Run unpatched dynamic binaries on NixOS. Needed for compilation (C, Rust).

      # Packages
      environment.systemPackages = with pkgs; [
        # Editor
        neovim # Vim-based text editor
        vscode # Visual Studio Code
        # Browser
        firefox # 🔥🦊
        brave # 🦁
        # Development
        git # Version control
        lazygit # Git TUI
        docker # Container management
        docker-compose # Multi-docker management
        python3 # Python programming language
        uv # Python package manager
        jq # JSON processor
        yq # YAML processor
        jnv # jq TUI
        jless # JSON viewer
        difftastic # Structural diff tool
        devenv # Development environment management
        dbeaver-bin # Database management
        # Office
        libreoffice # Office suite
        zathura # PDF viewer
        thunderbird # Email client
        obsidian # Note-taking app
        google-fonts # Google Fonts
        qalculate-gtk # Advanced calculator
        # Academic
        zotero # Reference manager
        typst # Latex alternative
        # Media
        vlc # Media player
        mpv # Media player
        spotify # Music streaming
        freetube # YouTube client
        # Graphics
        gimp # Image editor
        inkscape # Vector graphics editor
        swappy # Image editor
        # Password Manager
        keepassxc # Password manager
        # Utilities
        eza # ls replacement
        fd # Find replacement
        fselect # Query file system
        bat # Cat replacement
        bat-extras.core # Extras for bat
        glow # Markdown viewer
        ripgrep # grep replacement
        tlrc # Straightforward helper (tldr client)
        (btop.override { cudaSupport = true; }) # System monitor
        nvtopPackages.full # Nvidia GPU monitor
        mission-center # System information
        powertop # Power consumption monitor
        p7zip # Archive manager
        unzip # Archive manager
        ouch # Archive manager
        ddcutil # Monitor control utility
        zenity # Display GTK dialog boxes from shell scripts
        dysk # Disk usage analyzer
        dua # Disk usage analyzer
        # Network
        curl # cURL command-line tool
        wget # File downloader
        syncthing # File synchronization
        qbittorrent # Torrent client
        # Misc
        fastfetch # System information tool
        xdg-user-dirs # Manage XDG user directories
        # Nix
        nh # Glorified nixos/home-manager switch
        nps # Nix package searcher
        nil # LPS server
        nixfmt # Nix formatter
      ];
    };

  flake.homeModules.tesla =
    { pkgs, ... }:
    {
      imports = with inputs.self.homeModules; [
        base # Base home configuration
        # Shell
        bash
        zsh
        fish
        nushell
        startship # Shell prompt
        # Terminal
        tmux # Terminal multiplexer
        foot # Wayland terminal emulator
        # Development
        git # Git configuration
        virtmanager # virt-manager configuration
        # Desktop
        hyprland # Hyprland configuration
        # Utilities
        waybar # Wayland status bar
        dunst # Notification daemon
        rclone # Rsync-like program for cloud storage
        yazi # TUI File manager
      ];

      # Base
      base = {
        username = "samuel";
        stateVersion = "24.05";
      };

      # Style
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
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };

      # Disks
      services.udiskie.enable = true;

      # Environment variables
      home.sessionVariables = {
        EDITOR = lib.getExe pkgs.neovim;
        VISUAL = lib.getExe pkgs.vscode;
        MANPAGER = "env BATMAN_IS_BEING_MANPAGER=yes " + lib.getExe pkgs.bat-extras.batman;
      };
    };
}
