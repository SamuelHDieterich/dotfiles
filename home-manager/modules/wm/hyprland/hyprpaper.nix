{ lib, ... }: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/Pictures/Wallpaper/wallpaper" ];
      wallpaper = [ ", ~/Pictures/Wallpaper/wallpaper" ];
    };
  };
  # # Temporary fix: https://github.com/nix-community/home-manager/issues/5899#issuecomment-2498226238
  # systemd.user.services.hyprpaper.Unit.After =
  #   lib.mkForce "graphical-session.target";
}
