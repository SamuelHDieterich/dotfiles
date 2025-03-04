{ config, lib, pkgs, osConfig, ... }:
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
  };

  config = {
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
      gc = {
        automatic = true;
        frequency = "weekly";
        options = "--delete-older-than 15d";
      };
    } // lib.optionalAttrs (!osConfig.home-manager.useGlobalPkgs) {
      nixpkgs.config.allowUnfree = cfg.allowUnfree;
    };

    # Home
    home = {
      username = cfg.username;
      homeDirectory = cfg.homeDirectory;
    };

    # Home Manager
    ## Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    ## Check the documentation before changing this.
    home.stateVersion = "24.05";

  };
}
