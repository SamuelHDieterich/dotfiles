{ ... }:
{
  flake.homeModules.nushell = {
    programs.nushell = {
      enable = true;
      # Nushell uses a different alias system than POSIX shells
      shellAliases = {
        # Nix
        nix-shell = "nix-shell --run $env.SHELL";
      };
    };
  };
}
