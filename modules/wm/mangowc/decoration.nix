{
  flake.homeModules.mangowc = {
    wayland.windowManager.mango.settings = {
      # Dimensions
      borderpx = 2;
      gappih = 5;
      gappiv = 5;
      gappoh = 10;
      gappov = 10;
      border_radius = 10;
      # Colors
      focuscolor = "0x00ff99ee";
      bordercolor = "0x1a1a1aee";
    };
  };
}
