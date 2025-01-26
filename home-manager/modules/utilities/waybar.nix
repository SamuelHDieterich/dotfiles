{ config, ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # style = ./style.css;
    style = ''
      window#waybar {
        background: @theme_base_color;
        border-bottom: 1px solid @unfocused_borders;
        color: @theme_text_color;
        font-family: "JetBrainsMono Nerd Font Mono";
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 10;
        modules-left = [ "cpu" "memory" "network" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "pulseaudio" "battery" "clock" "tray" ];
        "hyprland/workspaces" = {
          active-only = true;
          all-outputs = false;
          show-special = true;
          special-visible-only = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "󰈹";
            "3" = "";
            "4" = "󰭹";
            "5" = "";
            "6" = "󰝚";
            "7" = "";
            "8" = "";
            "9" = "󰌽";
            "magic" = "";
          };
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "";
          format-icons = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" ];
          };
          on-click = "pavucontrol";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        "clock" = {
          format = "{:%d.%m.%Y - %H:%M}";
          format-alt = "{:%A, %B %d at %R}";
        };

        "tray" = {
          icon-size = 14;
          spacing = 1;
        };
      };
    };
  };
}
