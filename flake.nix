{
  description = "Dotfiles configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # OpenGL for non-NixOS systems
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Dynamic monitor management for Hyprland
    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, disko, lanzaboote, sops-nix, nixgl
    , hyprdynamicmonitors, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      # NixOS configurations
      nixosConfigurations = {
        home = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko # Disk management module
            ./nixos/profiles/home/disk-configuration.nix # Disk configuration
            lanzaboote.nixosModules.lanzaboote # Secure boot
            sops-nix.nixosModules.sops # Secrets management
            ./nixos/profiles/home/configuration.nix # Regular NiXOS configuration
            # Home Manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.samuel = import ./home-manager/profiles/home.nix;
                extraSpecialArgs = {
                  inherit system;
                  inherit inputs;
                };
              };
            }
          ];
        };
      };
      # Home Manager configurations for non-NixOS systems
      homeConfigurations =
        # Dynamically generate Home Manager configurations for each profile in home-manager/profiles
        builtins.listToAttrs (map (file: {
          name = builtins.replaceStrings [ ".nix" ] [ "" ] file;
          value = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              sops-nix.homeManagerModules.sops # Secrets management
              ./home-manager/profiles/${file}
            ];
            extraSpecialArgs = {
              inherit system;
              inherit inputs;
            };
          };
        }) (builtins.attrNames (builtins.readDir ./home-manager/profiles)));
    };
}
