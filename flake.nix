{
  description = "Dotfiles configuration";

  inputs = {
    # Package management
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Modular flake structure
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Recursively import nix modules
    import-tree.url = "github:vic/import-tree";
    # User-level configuration management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware";
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
    # Development environment management
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Dynamic monitor management for Hyprland
    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowc = {
      url = "github:ananyatimalsina/mangowc"; # https://github.com/mangowm/mango/pull/667
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager
        (inputs.import-tree [
          ./hosts # Device-specific configurations
          ./modules # General Nix modules
          ./packages # Custom packages
          # ./shells # Development shells
        ])
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ]; # Supported systems
    };
}
