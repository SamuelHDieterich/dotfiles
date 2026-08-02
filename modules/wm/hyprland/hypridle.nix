{
  flake.homeModules.hypridle =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        wlopm
        hyprlock
        wl-gammarelay-rs
      ];

      # DBus service exposing display gamma/brightness control (covers all
      # outputs, including external monitors) for the pre-lock dim warning.
      systemd.user.services.wl-gammarelay-rs = {
        Unit = {
          Description = "DBus service to control display gamma/brightness under Wayland";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.wl-gammarelay-rs} run";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      services.hypridle = {
        enable = true;
        settings =
          let
            dmps-on = "wlopm --on '*'";
            dmps-off = "wlopm --off '*'";
            is_locked = "pidof hyprlock";
            lock_cmd = "hyprlock";
            gamma-dim = pkgs.writeShellScript "gamma-dim" ''
              for b in 0.85 0.7 0.55 0.4 0.3; do
                busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d $b
                sleep 0.15
              done
            '';
            gamma-restore = "busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1";
          in
          {
            general = {
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "${dmps-on}; ${gamma-restore}";
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
                timeout = 570; # 9.5 minutes
                on-timeout = toString gamma-dim;
                on-resume = gamma-restore;
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
