{ inputs, ... }:
{
  flake.nixosModules.mangowc = {
    imports = [ inputs.mangowc.nixosModules.mango ];
    programs.mango.enable = true;
  };

  flake.homeModules.mangowc = {
    imports = with inputs.self.homeModules; [
      inputs.mangowc.hmModules.mango
      hyprlock
      hypridle
    ];
    wayland.windowManager.mango = {
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      # This should be a temporary workaround
      autostart_sh = "dbus-update-activation-environment --systemd --all";
    };
  };
}
