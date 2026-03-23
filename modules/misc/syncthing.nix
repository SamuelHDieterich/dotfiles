{ inputs, ... }:
{
  flake.modules.generic.syncthing = {
    services.syncthing = {
      enable = true;
    };
  };

  flake.nixosModules.syncthing = {
    imports = [ inputs.self.modules.generic.syncthing ];
  };

  flake.homeModules.syncthing = {
    imports = [ inputs.self.modules.generic.syncthing ];
  };
}
