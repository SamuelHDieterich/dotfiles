{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, disko, lanzaboote, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        home = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko # Disk management module
            ./profiles/home/disk-configuration.nix # Disk configuration
            lanzaboote.nixosModules.lanzaboote # Secure boot
            ./profiles/home/configuration.nix # Regular NiXOS configuration
            # Home Manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.samuel = import ../home-manager/profiles/home.nix;
                extraSpecialArgs = {
                  inherit system;
                  inherit inputs;
                };
              };
            }
          ];
        };
      };
    };
}
