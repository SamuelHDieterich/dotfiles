{
  flake-file.inputs = {
    # Development environment management
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
