{
  flake.homeModules.mangowc = {
    wayland.windowManager.mango.settings = {
      # Dimensions
      border_px = 2;
      gap_inner_horizontal = 5;
      gap_inner_vertical = 5;
      gap_outer_horizontal = 10;
      gap_outer_vertical = 10;
      border_radius = 10;
      # Colors
      focus_color = "0x00ff99ee";
      border_color = "0x1a1a1aee";
      # Hot corner: enter overview when the cursor hits a screen corner.
      enable_hotarea = 1;
      hotarea_corner = 2; # bottom-left
      hotarea_size = 10;
    };
  };
}
