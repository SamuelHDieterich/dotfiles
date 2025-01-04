{ ... }: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/Pictures/Wallpaper/wallpaper" ];
      wallpaper = [ ", ~/Pictures/Wallpaper/wallpaper" ];
    };
  };
}
