{ ... }: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock --grace 10";
      };

      listener = [
        {
          timeout = 5; # 5 seconds
          on-timeout =
            "pidof hyprlock && hyprctl dispatch dpms off"; # Turn off DPMS if locked
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600; # 10 minutes
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
