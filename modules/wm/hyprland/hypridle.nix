{
  flake.homeModules.hypridle =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wlopm
        hyprlock
      ];
      services.hypridle = {
        enable = true;
        settings =
          let
            dmps-on = "wlopm --on '*'";
            dmps-off = "wlopm --off '*'";
            is_locked = "pidof hyprlock";
            lock_cmd = "hyprlock --grace 10";
          in
          {
            general = {
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = dmps-on;
              ignore_dbus_inhibit = false;
              lock_cmd = "${is_locked} || ${lock_cmd}"; # Lock if not already locked
            };

            listener = [
              {
                timeout = 5; # 5 seconds
                on-timeout = "${is_locked} && ${dmps-off}"; # Turn off DPMS if locked
                on-resume = dmps-on;
              }
              {
                timeout = 600; # 10 minutes
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 900; # 15 minutes
                on-timeout = dmps-off;
                on-resume = dmps-on;
              }
              {
                timeout = 1200; # 20 minutes
                on-timeout = "systemctl suspend";
              }
            ];
          };
      };
    };
}
