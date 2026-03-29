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
    specialArgs = { inherit inputs; };
    modules = [
      inputs.self.nixosModules.${hostname}
      { nixpkgs.hostPlatform = lib.mkDefault system; }
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };
          users.${username} = inputs.self.homeModules.${hostname};
        };
      }
    ];
  };

  flake.homeConfigurations.${hostname} = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${system};
    extraSpecialArgs = { inherit inputs; };
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
        # Hardware modules
        audio # Audio configuration
        time # Time synchronization
        power # Power management
        bluetooth # Bluetooth support
        # Display Manager modules
        greetd # Greetd display manager
        # Window Manager modules
        mangowc # Mango window manager
        # Development modules
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

      # Boot
      lanzaboote.kernelPackages = pkgs.linuxPackages;

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
      programs = {
        nix-index.enable = true; # Index nixpkgs for quick searching (includes shell integration).
        nix-ld.enable = true; # Run unpatched dynamic binaries on NixOS. Needed for compilation (C, Rust).
      };

      # Packages
      metapackages.bundles = bundles;
      environment.systemPackages = with pkgs; [
        # Editor
        neovim # Vim-based text editor
        vscode # Visual Studio Code
        # Browser
        firefox # 🔥🦊
        brave # 🦁
      ];
    };

  flake.homeModules.${hostname} =
    { pkgs, lib, ... }:
    {
      imports = with inputs.self.homeModules; [
        base # Base home configuration
        shell # Shell
        # Terminal
        tmux # Terminal multiplexer
        foot # Wayland terminal emulator
        # Development
        git # Git configuration
        # Desktop
        mangowc # Mango configuration
        # Utilities
        waybar # Wayland status bar
        dunst # Notification daemon
        rclone # Rsync-like program for cloud storage
        yazi # TUI file manager
        syncthing # File synchronization
      ];

      # Base
      base = {
        username = username;
        stateVersion = stateVersion;
      };

      # Shell
      shell.include = [
        "bash"
        "zsh"
        "fish"
        "nushell"
      ];

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

      # Wayland: displays
      services.kanshi = {
        enable = true;
        settings = [
          {
            profile.name = "undocked";
            profile.outputs = [ { criteria = "eDP-1"; } ];
          }
          {
            profile.name = "semi-docked";
            profile.outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
              }
              {
                criteria = "HDMI-A-1";
                position = "1920,0";
              }
            ];
          }
          {
            profile.name = "fully-docked";
            profile.outputs = [
              {
                criteria = "HDMI-A-1";
                position = "0,0";
              }
              {
                criteria = "eDP-1";
                position = "1920,0";
              }
              {
                criteria = "DP-1";
                position = "3840,0";
              }
            ];
          }
        ];
      };
    };
}
