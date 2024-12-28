{ ... }: {
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      resize_on_border = true;
      allow_tearing = false;
      layout = "dwindle";
    };
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };
    decoration = {
      rounding = 10;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aee)";
      };
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
        vibrancy = 0.1696;
      };
    };
  };
}
