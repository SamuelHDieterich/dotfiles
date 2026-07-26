{
  flake.homeModules.waybar =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        style = ./style.css;
        settings = {
          mainBar = {
            # General
            layer = "top";
            position = "top";
            height = 20;
            spacing = 10;

            # Positioning
            modules-left =
              lib.optionals (config.wayland.windowManager.hyprland.enable) [
                "hyprland/workspaces"
              ]
              ++ lib.optionals (config.wayland.windowManager.mango.enable) [
                "mango/workspaces"
                "mango/layout"
              ];
            modules-center = lib.optionals (config.wayland.windowManager.mango.enable) [
              "mango/window"
            ];
            modules-right = [
              "tray"
              "cpu"
              "memory"
              "network"
              "pulseaudio"
              # "disk"
              "battery"
              "clock"
              "idle_inhibitor"
            ];

            # Modules

            ## Window manager
            "hyprland/workspaces" = {
              active-only = false;
              all-outputs = false;
              show-special = true;
              special-visible-only = true;
              on-scroll-up = "hyprctl dispatch workspace e+1";
              on-scroll-down = "hyprctl dispatch workspace e-1";
            };

            "mango/workspaces" = {
              format = "{icon}";
              on-click = "activate";
              on-click-right = "toggle";
            };

            "mango/window" = {
              format = "{title}";
              max-length = 50;
            };

            "mango/layout" = {
              format = "[{symbol}]";
              icon-size = 0;
              tooltip = false;
              on-click = "mmsg dispatch switch_layout";
            };

            ## System
            "cpu" = {
              interval = 1;
              format = "CPU: {usage}%";
              on-click = "xdg-terminal-exec ${lib.getExe pkgs.btop}";
            };

            "memory" = {
              interval = 1;
              format = "Mem: {percentage}%";
              tooltip-format = "Memory: {used:0.2f}GiB / {total:0.2f}GiB ({percentage}%)\nSwap: {swapUsed:0.2f}GiB / {swapTotal:0.2f}GiB ({swapPercentage}%)";
              on-click = "xdg-terminal-exec ${lib.getExe pkgs.btop}";
            };

            "network" = {
              interval = 5;
              format = "Net: {bandwidthDownBytes} ↓ {bandwidthUpBytes} ↑";
              format-disconnected = "No network";
              tooltip-format = "{ifname} via {gwaddr} 󰊗";
              tooltip-format-wifi = "{essid} ({signalStrength}%) ";
              tooltip-format-ethernet = "{ifname} ";
              tooltip-format-disconnected = "Disconnected";
              on-click = "nm-connection-editor"; # May add logic to check if NetworkManager is installed
            };

            "pulseaudio" = {
              format = "{icon} {volume}% | {format_source}";
              format-bluetooth = "{icon} {volume}%  | {format_source}";
              format-muted = "{icon} Muted | {format_source}";
              format-source = "󰍬";
              format-source-muted = "󰍭";
              format-icons = {
                default = [
                  ""
                  ""
                  ""
                ];
                headphone = "";
                headphone-muted = "󰟎";
                speaker = "󰓃";
                speaker-muted = "󰓄";
                hdmi = "󰡁";
                headset = "󰋎";
                headset-muted = "󰋐";
                hands-free = "";
                portable = "";
                portable-muted = "";
                car = "";
                car-muted = "󰸜";
                hifi = "󰴸";
                hifi-muted = "󰓄";
                phone = "";
              };
              on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
              on-click-middle = "pavucontrol";
              on-click-right = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
            };

            "disk" = {
              interval = 60;
              paths = "/";
              format = "Disk: {free}";
              tooltip-format = "{used} / {total} ({percentage}%)";
            };

            "battery" = {
              interval = 10;
              states = {
                warning = 30;
                critical = 10;
              };
              format = "{icon} {capacity}%";
              format-charging = " {capacity}%";
              format-alt = "{time} {icon}";
              format-icons = [
                "󰂎"
                "󰁼"
                "󰁿"
                "󰂁"
                "󰁹"
              ];
              tooltip-format = "{power}W - {timeTo}";
            };

            "clock" = {
              interval = 1;
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "month";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                on-click-right = "mode";
              };
              actions = {
                on-click-right = "mode";
                on-click-forward = "tz_up";
                on-click-backward = "tz_down";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
              format = " {:%Y-%m-%d  %H:%M:%S}";
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
    };
}
