{ config, lib, pkgs, ... }:
with lib;
let cfg = config.base;
in {

  # Options
  options.base = {
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
    # Nix
    nixpkgs.config.allowUnfree = cfg.allowUnfree;
    nix = {
      package = pkgs.nix;
      settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 15d";
      };
    };
    system.stateVersion = cfg.version;

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
    i18n = { defaultLocale = "en_US.UTF-8"; };

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

    # Environment variables
    environment.sessionVariables = rec {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      ZDOTDIR = "${XDG_CONFIG_HOME}/zsh";
      HISTFILE = "${XDG_STATE_HOME}/zsh/history";
      CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
      GTK2_RC_FILES = "${XDG_CONFIG_HOME}/gtk-2.0/gtkrc";
      XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
    };
  };
}
