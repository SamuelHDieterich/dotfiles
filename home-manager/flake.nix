{
  description = "Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf-config = {
      url = "path:./modules/dev/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nvf-config, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          # Overlay to replace neovim with nvf-neovim
          (final: prev: { neovim = nvf-config.packages.${system}.default; })
        ];
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
