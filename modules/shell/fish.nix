{
  flake.homeModules.fish =
    { lib, ... }:
    with lib;
    {
      programs.fish = {
        enable = mkDefault false;
      };
    };
}
