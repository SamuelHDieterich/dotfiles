{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings.exec-once = [
    "${pkgs.networkmanagerapplet}/bin/nm-applet"
    "${pkgs.wbg}/bin/wbg -s ~/Pictures/Wallpaper/wallpaper"
  ];
}
