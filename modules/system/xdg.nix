{ inputs, ... }:
{
  flake.modules.generic.xdg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      xdg.portal = {
        enable = true;
        config.common.default = [
          "wlr"
          "gtk"
        ];
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
      };
    };

  flake.nixosModules.xdg =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.modules.generic.xdg
      ];
    };

  flake.homeModules.xdg =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.modules.generic.xdg
      ];
    };
}
