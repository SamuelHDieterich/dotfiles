{
  flake.homeModules.hyprland =
    { pkgs, ... }:
    {
      wayland.windowManager.hyprland.settings.exec-once = [
        "nm-applet" # networkmanagerapplet
        "wbg -s ~/Pictures/Wallpaper/wallpaper"
      ];

      home.packages = with pkgs; [
        networkmanagerapplet
        wbg
      ];
    };
}
