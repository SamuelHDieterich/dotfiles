{
  config,
  inputs,
  lib,
  ...
}:
let
  system = "x86_64-linux";
  stateVersion = "24.05";
  hostname = "installer";
  inherit (config.dotfiles) sshKeys;
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.nixosModules.${hostname}
      { nixpkgs.hostPlatform = lib.mkDefault system; }
    ];
  };

  flake.packages.${system}.installer-iso =
    inputs.self.nixosConfigurations.${hostname}.config.system.build.isoImage;

  flake.nixosModules.${hostname} =
    { modulesPath, pkgs, ... }:
    {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      ];

      # Image
      # zstd builds much faster than the default xz
      isoImage.squashfsCompression = "zstd -Xcompression-level 6";

      networking.hostName = hostname;
      system.stateVersion = stateVersion;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };

      users.users.root.openssh.authorizedKeys.keys = sshKeys;

      environment.systemPackages = with pkgs; [
        neovim # editor
        git # version control
        nh # nix helper
        btop # monitor
        nixos-facter # hardware reports
        tmux # multiplexer
      ];
    };
}
