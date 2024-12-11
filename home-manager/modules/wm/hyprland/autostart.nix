{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wbg
  ];

  wayland.windowManager.hyprland.settings.exec-once = [
    "wbg ~/Pictures/Wallpaper/wallpaper"
  ];
}