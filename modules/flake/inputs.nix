{ inputs, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake-file.inputs = {
    # Package management
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # User-level configuration management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
