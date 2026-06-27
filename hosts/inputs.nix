{
  flake-file.inputs = {
    # Disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hardware support
    ## PR with ThinkPad E14 Gen 7
    nixos-hardware.url = "github:NixOS/nixos-hardware/pull/1700/head";
  };
}
