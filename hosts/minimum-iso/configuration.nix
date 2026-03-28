{ inputs, lib, ... }:
let
  system = "x86_64-linux";
  stateVersion = "24.05";
  hostname = "minimum-iso";
  rootAuthorizedKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANBmVVJXeQrw57e3t0JX+dbPz6rYUAVT0z6IurSoLqS samuel@tesla";
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      inputs.self.nixosModules.${hostname}
      { nixpkgs.hostPlatform = lib.mkDefault system; }
    ];
  };

  flake.nixosModules.${hostname} =
    { modulesPath, pkgs, ... }:
    {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      ];

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

      users.users.root.openssh.authorizedKeys.keys = [ rootAuthorizedKey ];

      environment.systemPackages = with pkgs; [
        neovim
        git
        nh
        btop
      ];
    };
}
