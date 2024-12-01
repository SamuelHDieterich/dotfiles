{...}: {
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "br,us";
      kb_variant = "abnt2,intl";
      kb_options = "grp:alt_shift_toggle";
      touchpad.natural_scroll = true;
      sensitivity = 0;
      force_no_accel = 0;
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
    };
  };
}