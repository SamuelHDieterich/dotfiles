{ inputs, ... }:
{
  flake.nixosModules.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.base;
    in
    {
      imports = with inputs.self.nixosModules; [
        # Secrets
        sops
        # _module.args injects extra arguments into all imported modules; this supplies `keyfile`.
        { _module.args.keyfile = "/home/${cfg.username}/.config/sops/age/keys.txt"; }
        # Environment variables
        sessionVariables
        # Package bundles
        metapackages
      ];

      options.base = {
        allowUnfree = mkOption {
          type = types.bool;
          default = true;
          description = "Allow unfree packages.";
        };
        version = mkOption {
          type = types.str;
          default = "24.05";
          description = "The NixOS configuration version.";
        };
        bootloader = mkOption {
          type = types.str;
          default = "systemd-boot";
          description = "The bootloader to use: grub or systemd-boot.";
        };
        hostname = mkOption {
          type = types.str;
          default = "nixos";
          description = "The hostname of the machine.";
        };
        username = mkOption {
          type = types.str;
          default = "samuel";
          description = "The username of the user.";
        };
        shell = mkOption {
          type = types.enum [
            "bash"
            "zsh"
            "fish"
          ];
          default = "zsh";
          description = "The default shell for the user.";
        };
      };

      config = {
        # Nix
        nixpkgs.config.allowUnfree = cfg.allowUnfree;
        nix = {
          package = pkgs.nix;
          settings = {
            auto-optimise-store = true;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            trusted-users = [
              "root"
              "@wheel"
            ];
            use-xdg-base-directories = true;
          };
          extraOptions = "!include ${config.sops.templates.nix-access-token.path}";
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 15d";
          };
        };
        system.stateVersion = cfg.version;

        # Firmware
        services.fwupd.enable = true;

        # Boot
        boot = {
          loader = {
            "${cfg.bootloader}".enable = true;
            efi.canTouchEfiVariables = true;
          };
        };

        # Networking
        networking = {
          hostName = cfg.hostname;
          networkmanager.enable = true;
          firewall.enable = true;
        };

        # Time
        time.timeZone = "America/Sao_Paulo";

        # Internationalization
        i18n = {
          defaultLocale = "en_US.UTF-8";
        };

        # Keyboard
        console = {
          keyMap = "br-abnt2";
          font = "Lat2-Terminus16";
        };
        services.xserver.xkb = {
          layout = "br";
          model = "abnt2";
        };

        # Users
        users.users = {
          "${cfg.username}" = {
            isNormalUser = true;
            shell = pkgs.${cfg.shell};
            extraGroups = [
              "wheel" # For sudo access
              "networkmanager" # For NetworkManager access
              "video" # For GPU access
              "audio" # For audio access
              "storage" # For storage device access
              "docker" # For Docker access
              "libvirt" # For libvirt (virtualization) access
              "libvirtd" # For libvirt daemon access
              "lp" # For printer access
              "scanner" # For scanner access
              "i2c" # For I2C device access
            ];
          };
        };

        # Shell
        programs.${cfg.shell}.enable = true;

        # Packages
        environment.systemPackages = with pkgs; [
          xdg-user-dirs # Manage XDG user directories
        ];
      };
    };

  flake.homeModules.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.base;
    in
    {
      imports = with inputs.self.homeModules; [
        # Secrets
        sops
        # _module.args injects extra arguments into all imported modules; this supplies `keyfile`.
        { _module.args.keyfile = "/home/${cfg.username}/.config/sops/age/keys.txt"; }
        # Environment variables
        sessionVariables
        # Package bundles
        metapackages
      ];

      options.base = {
        username = mkOption {
          type = types.str;
          default = "samuel";
          description = "The username of the user.";
        };
        homeDirectory = mkOption {
          type = types.str;
          default = "/home/${cfg.username}";
          description = "The home directory of the user.";
        };
        stateVersion = mkOption {
          type = types.str;
          default = "24.05";
          description = "The Home Manager configuration version.";
        };
      };

      config = {
        # Home
        home = {
          username = cfg.username;
          homeDirectory = cfg.homeDirectory;
        };

        # Nix
        nix = {
          settings = {
            auto-optimise-store = true;
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            use-xdg-base-directories = true;
          };
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 15d";
          };
        };

        # Environment variables
        xdg = {
          enable = true;
          cacheHome = "${cfg.homeDirectory}/.cache";
          configHome = "${cfg.homeDirectory}/.config";
          dataHome = "${cfg.homeDirectory}/.local/share";
          stateHome = "${cfg.homeDirectory}/.local/state";
        };
        home.preferXdgDirectories = true;

        # Home Manager
        ## Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
        ## Check the documentation before changing this.
        home.stateVersion = cfg.stateVersion;
      };
    };
}
