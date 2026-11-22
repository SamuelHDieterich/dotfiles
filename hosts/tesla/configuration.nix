{ inputs, lib, ... }:
let
  system = "x86_64-linux";
  stateVersion = "26.05";
  username = "samuel";
  hostname = "tesla";
  bundles = [
    "development"
    "office"
    "fonts"
    "academic"
    "media"
    "graphics"
    "security"
    "utilities"
    "network"
    "nix"
  ];
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.nixosModules.${hostname}
      { nixpkgs.hostPlatform = lib.mkDefault system; }
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = inputs.self.homeModules.${hostname};
        };
      }
    ];
  };

  flake.homeConfigurations.${hostname} = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
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

  flake.nixosModules.${hostname} =
    { config, pkgs, ... }:
    {
      # Add modules
      imports = with inputs.self.nixosModules; [
        # Operating System modules
        base # Base system configuration
        lanzaboote # Secure boot configuration
        xdg # XDG portals
        desktop # Keyring, disks, thumbnails, fonts and desktop programs
        # Hardware modules
        nvidia # Nvidia GPU support
        audio # Audio configuration
        time # Time synchronization
        power # Power management
        bluetooth # Bluetooth support
        # Display Manager modules
        greetd # Greetd display manager
        # Window Manager modules
        # hyprland # Hyprland window manager
        mangowc # Mango window manager
        # Development modules
        virtmanager # Virtual machine management with virt-manager
        tailscale # Tailscale VPN client
        podman # Podman container runtime
        # Misc modules
        printing # Printer and scanner support
        obs-studio # OBS Studio for screen recording and streaming
        thunar # Thunar file manager
        games # Games and emulators
      ];

      # Base configuration
      base = {
        hostname = hostname;
        version = stateVersion; # Not recommended to change this
        username = username;
        allowUnfree = true;
      };

      keyboard = [
        {
          layout = "br";
          consoleKeyMap = "br-abnt2";
        }
        {
          layout = "us";
          variant = "intl";
        }
      ];

      # Secrets
      ## This laptop decrypts with Samuel's personal age key.
      sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

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

      # Packages
      metapackages.bundles = bundles;
      environment.systemPackages = with pkgs; [
        # Editor
        vscode # Visual Studio Code
        # Development
        beads
        inputs.self.packages.${system}.bead-me-up-scotty # Local web UI for the beads (bd) issue tracker
        # Browser
        firefox # 🔥🦊
        brave # 🦁
        # Network
        qbittorrent # Torrent client
      ];
    };

  flake.homeModules.${hostname} =
    { ... }:
    {
      imports = with inputs.self.homeModules; [
        base # Base home configuration
        shell # Shell
        # Terminal
        tmux # Terminal multiplexer
        foot # Wayland terminal emulator
        # Development
        git # Git configuration
        devenv # Development environment with nix
        neovim # IDE-like Neovim (nixvim)
        claudeCode # Anthropic coding agent
        virtmanager # virt-manager configuration
        tailscale # Tailscale systray
        # Desktop
        # hyprland # Hyprland configuration
        mangowc # Mango configuration
        desktop # Removable disks, default editor and man pager
        theme # Cursor, GTK theme and dark mode
        kanshi # Display profiles
        # Utilities
        waybar # Wayland status bar
        dunst # Notification daemon
        rclone # Rsync-like program for cloud storage
        yazi # TUI file manager
        thunar # Thunar terminal helper config
        syncthing # File synchronization
      ];

      # Base
      base = {
        username = username;
        stateVersion = stateVersion;
      };

      keyboard = [
        { layout = "br"; }
        {
          layout = "us";
          variant = "intl";
        }
      ];

      # Shell
      shell.include = [
        "bash"
        "zsh"
        "fish"
        "nushell"
      ];
    };
}
