{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings.exec-once =
    [ "${pkgs.networkmanagerapplet}/bin/nm-applet" ];
}
