{ ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # style = ./style.css;
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font Mono";
        font-size: 10px;
        border-radius: 8px;
        min-height: 0;
        border: none;
        font-weight: bold;
      }

      #workspaces {
        background-color: rgba(24, 24, 37, 1.0);
        border: none;
        box-shadow: none;
      }

      #tray {
        margin: 6px 3px;
        background-color: rgba(36, 36, 52, 1.0);
        padding: 6px 12px;
        border-radius: 6px;
        border-width: 0px;
      }

      #waybar {
        background: transparent;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      #window,
      #clock,
      #bluetooth,
      #battery,
      #pulseaudio,
      #backlight,
      #memory,
      #cpu,
      #idle_inhibitor,
      #network {
        margin: 6px 3px;
        padding: 6px 12px;
        background-color: #1e1e2e;
        color: #181825;
      }

      #clock {
        background-color: #89b4fa;
      }
      #bluetooth {
        background-color: #f9e2af;
      }
      #battery {
        background-color: #cba6f7;
      }
      #pulseaudio {
        background-color: #89dceb;
      }
      #backlight {
        background-color: #a6a3a1;
      }
      #memory {
        background-color: #f7768e;
      }
      #cpu {
        background-color: #f38ba8;
      }
      #network {
        background-color: #fab387;
      }
      #custom-lock {
        background-color: #94e2d5;
      }
      #window {
        background-color: #74c7ec;
      }

      #waybar.hidden {
        opacity: 0.5;
      }

      #workspaces button {
        all: initial;
        /* Remove GTK theme values (waybar #1351) */
        min-width: 0;
        /* Fix weird spacing in materia (waybar #450) */
        box-shadow: inset 0 -3px transparent;
        /* Use box-shadow instead of border so the text isn't offset */
        border-radius: 8px;
        padding: 6px 12px;
        margin: 6px 3px;
        background-color: rgba(36, 36, 52, 1.0);
        color: #cdd6f4;
      }

      #workspaces button.active {
        color: #1e1e2e;
        background-color: #cdd6f4;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        color: #1e1e2e;
        background-color: #cdd6f4;
      }

      tooltip {
        border-radius: 8px;
        padding: 16px;
        background-color: #131822;
        color: #C0C0C0;
      }

      tooltip label {
        padding: 5px;
        background-color: #131822;
        color: #C0C0C0;
      }

      #idle_inhibitor {
        color: #ededed;
        font-size: 14px;
      }
      #idle_inhibitor.activated {
        background-color: #653734;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        spacing = 10;

        modules-left = [ "cpu" "memory" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right =
          [ "idle_inhibitor" "pulseaudio" "battery" "clock" "tray" ];

        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = false;
          show-special = true;
          special-visible-only = true;
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          # format = "{icon}";
          # format-icons = {
          #   "1" = "";
          #   "2" = "󰈹";
          #   "3" = "";
          #   "4" = "󰭹";
          #   "5" = "";
          #   "6" = "󰝚";
          #   "7" = "";
          #   "8" = "";
          #   "9" = "󰌽";
          #   "magic" = "";
          # };
        };

        "cpu" = {
          interval = 1;
          format = "{icon} {usage}%";
          format-icons = [ "󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥" ];
          on-click = "kitty -e btop --preset 1";
        };

        "memory" = {
          interval = 1;
          format = "{icon} {percentage}%";
          format-icons = [ "󰝦" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥" ];
          on-click = "kitty -e btop --preset 1";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "󰝟";
          format-icons = {
            "default" = [ "" "" "" ];
            "headphone" = "";
            "speaker" = "󰜟";
            "hdmi" = "󰡁";
            "headset" = "";
            "hands-free" = "";
            "portable" = "";
            "car" = "";
            "hifi" = "󰴸";
            "phone" = "";
          };
          on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-middle = "pavucontrol";
        };

        "battery" = {
          interval = 10;
          states = {
            warning = 30;
            critical = 5;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "󰂎" "󰁼" "󰁿" "󰂁" "󰁹" ];
          tooltip-format = "{power}W - {timeTo}";
        };

        "clock" = {
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
          format = " {:%Y-%m-%d  %H:%M:%S}";
          interval = 1;
        };

        "tray" = {
          icon-size = 14;
          spacing = 1;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            "activated" = "󰈈";
            "deactivated" = "󰈉";
          };
        };
      };
    };
  };
}
