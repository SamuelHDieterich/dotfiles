{ ... }: {
  programs = {
    hyprland = {
      enable = true; # enable Hyprland
      xwayland.enable = true; # enable XWayland
    };
  };
  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
