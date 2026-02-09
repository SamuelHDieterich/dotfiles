{ inputs, ... }:
{
  flake.nixosModules.hyprland = {
    programs = {
      hyprland = {
        enable = true;
        xwayland.enable = true;
      };
    };
    security.pam.services.hyprlock = { };
    # Hint electron apps to use wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };

  flake.homeModules.hyprland = {
    imports = with inputs.self.homeModules; [
      # hyprpaper # Using wbg in autostart instead
      hyprlock
      hypridle
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.variables = [ "--all" ];
    };
  };
}
