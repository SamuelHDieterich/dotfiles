{
  description = "Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ];
        config = { };
      };
    in {
      homeConfigurations = {
        home = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./profiles/home.nix ];
          extraSpecialArgs = {
            inherit system;
            inherit inputs;
          };
        };
        work = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./profiles/work.nix ];
          extraSpecialArgs = {
            inherit system;
            inherit inputs;
          };
        };
      };
    };
}
