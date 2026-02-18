/*
  This module provides the configuration for Lanzaboote, a secure bootloader for NixOS. It replaces the default systemd-boot bootloader and integrates with sbctl for secure boot management.
  >> github.com/nix-community/lanzaboote
*/

{ inputs, ... }:
{
  flake.nixosModules.lanzaboote =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.lanzaboote;
    in
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      options.lanzaboote = {
        kernelPackages = lib.mkOption {
          type = lib.types.attrs;
          default = pkgs.linuxPackages;
          description = "The kernel package to use.";
        };
      };

      config = {
        # Boot and kernel
        boot = {
          loader = {
            timeout = 0; # Skip boot menu, press "space" key to show it
            efi.canTouchEfiVariables = true;
          };
          initrd.systemd.enable = true;
          loader.systemd-boot = {
            enable = lib.mkForce false; # Use Lanzaboote
            editor = false; # Prevent editing boot entries
          };
          # Secure boot
          lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
          };
          kernelPackages = cfg.kernelPackages;
        };
      };
    };
}
