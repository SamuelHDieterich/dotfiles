{
  flake.homeModules.mangowc =
    { pkgs, ... }:
    {
      wayland.windowManager.mango.settings.exec_once = [
        "nm-applet" # networkmanagerapplet
        "wbg -s ~/Pictures/Wallpaper/wallpaper"
      ];

      home.packages = with pkgs; [
        networkmanagerapplet
        wbg
      ];
    };
}
