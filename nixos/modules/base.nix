{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.base;
in {

  # Options
  options.base = {
    nixos = {
      allowUnfree = mkOption {
        type = types.bool;
        default = true;
        description = "Allow unfree packages.";
      };
      version = mkOption {
        type = types.str;
        default = "24.05";
        description = "The NixOS version.";
      };
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
  };

  config = {
    # Nix & NixOS
    nixpkgs.config.allowUnfree = cfg.nixos.allowUnfree;
    nix = {
      package = pkgs.nix;
      settings.experimental-features = ["nix-command" "flakes"];
    };
    system.stateVersion = cfg.nixos.version;

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
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "audio"
          "storage"
          "docker"
          "libvirt"
          "lp"
          "scanner"
        ];
      };
    };
    
    # Shell
    programs.zsh.enable = true;
  };
 }
