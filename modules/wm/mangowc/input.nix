{
  flake.homeModules.mangowc = {
    wayland.windowManager.mango.settings = {
      # Keyboard
      numlockon = 1; # Enable numlock on startup
      xkb_rules = {
        layout = "br,us";
        variant = "abnt2,intl";
        options = "grp:alt_shift_toggle";
      };
      # Trackpad
      trackpad_natural_scrolling = false;
    };
  };
}
