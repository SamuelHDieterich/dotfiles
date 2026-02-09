{ inputs, ... }:
{
  flake.homeModules.fish =
    { config, ... }:
    {
      imports = [ inputs.self.homeModules.shell-common ];

      programs.fish = {
        enable = true;
        shellAliases = config.shellAliases;
      };
    };
}
