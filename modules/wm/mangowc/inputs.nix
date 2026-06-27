{
  flake-file.inputs = {
    # Window manager
    mangowc = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Screenshot tool
    msnap = {
      url = "github:xtheeq/msnap";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
