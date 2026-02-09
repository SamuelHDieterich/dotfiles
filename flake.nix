{
  description = "Dotfiles configuration";

  inputs = {
    # Package management
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Modular flake structure
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Flake utilities (shared)
    flake-utils.url = "github:numtide/flake-utils";
    # Flake compatibility (shared)
    flake-compat.url = "github:NixOS/flake-compat";
    # Gitignore patterns (shared)
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.inputs = {
          flake-compat.follows = "flake-compat";
          gitignore.follows = "gitignore";
        };
      };
    };
    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # OpenGL for non-NixOS systems
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    # Development environment management
    devenv = {
      url = "github:cachix/devenv";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
        git-hooks.inputs.gitignore.follows = "gitignore";
      };
    };
    # Dynamic monitor management for Hyprland
    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
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
