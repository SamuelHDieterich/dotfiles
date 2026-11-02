{
  flake.homeModules.nushell =
    { lib, ... }:
    with lib;
    {
      programs.nushell = {
        enable = mkDefault false;
        loadSessionVariables = true;
        # Nushell uses a different alias system than POSIX shells
        shellAliases = {
          # Nix
          nix-shell = "nix-shell --run $env.SHELL";
        };
      };
    };
}
