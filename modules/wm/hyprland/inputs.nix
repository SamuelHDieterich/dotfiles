{
  flake-file.inputs = {
    # Dynamic monitors for Hyprland
    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
