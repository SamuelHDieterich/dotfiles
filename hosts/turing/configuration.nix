{ inputs, lib, ... }:
let
  system = "x86_64-linux";
  stateVersion = "26.05";
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
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel-gen7
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
    pkgs = inputs.nixpkgs.legacyPackages.${system};
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
        audio # Audio configuration
        time # Time synchronization
        power # Power management
        bluetooth # Bluetooth support
        fingerprint # Fingerprint reader (password-first, swipe as fallback)
        # Display Manager modules
        greetd # Greetd display manager
        # Window Manager modules
        mangowc # Mango window manager
        # Development modules
        virtmanager # Virtual machine management with virt-manager
        podman # Podman container runtime
        tailscale # Tailscale VPN client
        # Misc modules
        thunar # Thunar file manager
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
          variant = "thinkpad"; # Default (abnt2)
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
        # Browser
        firefox # 🔥🦊
        brave # 🦁
        # Office
        typst
        # Development
        beads
        inputs.self.packages.${system}.bead-me-up-scotty # Local web UI for the beads (bd) issue tracker
        jdk # Java Development Kit
        # Work-tools
        slack # Slack client
        ollama-vulkan # Local LLM
        llama-cpp-vulkan # Local LLM
        opencode # AI coding agent
        tigervnc # VNC server for remote desktop access
      ];
    };

  flake.homeModules.${hostname} =
    { lib, ... }:
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
        tailscale # Tailscale systray
        # Desktop
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
        {
          layout = "br";
          variant = "thinkpad"; # Default (abnt2)
        }
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

      # Claude Code: per folder login
      claudeCode.accounts = {
        kalanos = {
          paths = [ "/home/${username}/Projects/Kalanos" ];
        };
      };

      # Wayland: displays
      services.kanshi.settings = lib.mkBefore [
        {
          profile.name = "semi-docked-samsung-ls27d300g"; # Workplace
          profile.outputs = [
            {
              criteria = "eDP-1";
              position = "0,1080";
            }
            {
              # Match this exact display model/serial first.
              criteria = "Samsung Electric Company LS27D300G H1AK500000";
              position = "0,0";
            }
          ];
        }
      ];
    };
}
