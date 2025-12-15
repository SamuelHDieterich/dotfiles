{ pkgs, ... }:
let
  adjust-brightness = pkgs.writeShellScript "adjust-brightness"
    (builtins.readFile ../../../../scripts/adjust-brightness.sh);
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 600; # 10 minutes
          on-timeout = "${adjust-brightness} set 30";
          on-resume = "${adjust-brightness} reset";
        }
        {
          timeout = 720; # 12 minutes
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900; # 15 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1200; # 20 minutes
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
