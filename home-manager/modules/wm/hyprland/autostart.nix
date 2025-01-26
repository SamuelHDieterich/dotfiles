{ pkgs, lib, ... }: {
  wayland.windowManager.hyprland.settings.exec-once = [
    # "${pkgs.wbg}/bin/wbg ~/Pictures/Wallpaper/wallpaper" # Stopped working
    "systemctl --user enable --now hyprpaper.service" # Temporary fix
    "systemctl --user start waybar.service"
    "${
      lib.getExe' pkgs.wl-clipboard "wl-paste"
    } --type text --watch ${pkgs.cliphist} store"
    "${
      lib.getExe' pkgs.wl-clipboard "wl-paste"
    } --type image --watch ${pkgs.cliphist} store"
  ];
}
