{ ... }: {
  programs.hyprlock = {
    enable = true;
    # Grace option is no longer configurable -> hyprlock --grace <seconds>
    settings = {
      general = { hide_cursor = true; };

      label = {
        text = "$TIME";
        font_size = 96;
        font_family = "JetBrainsMono Nerd Font Mono";
        color = "rgb(255, 255, 255)";
        position = "0, 100";
        halign = "center";
        walign = "center";

        shadow_passes = 1;
      };

      background = [{
        # path = "screenshot";
        path = "~/Pictures/Wallpaper/wallpaper";
        blur_passes = 3;
        blur_size = 8;
        crossfade_time = 5; # seconds
      }];

      input-field = [{
        size = "300, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        font_color = "rgb(255, 255, 255)";
        inner_color = "rgb(40, 40, 40)";
        outer_color = "rgb(60, 60, 60)";
        outline_thickness = 5;
        placeholder_text = "Password";
        shadow_passes = 1;
      }];
    };
  };
}
