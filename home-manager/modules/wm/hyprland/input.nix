{ ... }: {
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "br,us";
      kb_variant = "abnt2,intl";
      kb_options = "grp:alt_shift_toggle";
      numlock_by_default = true;
      touchpad.natural_scroll = true;
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
    };
  };
}
