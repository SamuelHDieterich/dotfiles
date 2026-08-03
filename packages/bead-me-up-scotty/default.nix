{
  perSystem =
    { pkgs, ... }:
    {
      packages.bead-me-up-scotty = pkgs.callPackage ./_package.nix { };
    };
}
