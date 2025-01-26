{ ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      label = {
        text = "$TIME";
        font_size = 96;
        font_family = "JetBrainsMono Nerd Font Mono";
        color = "rgb(255, 255, 255)";
        position = "0, 600";
        halign = "center";
        walign = "center";

        shadow_passes = 1;
      };

      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
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
