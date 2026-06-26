{
  flake.nixosModules.greetd =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        restart = true;
        settings = {
          default_session =
            let
              desktops = config.services.displayManager.sessionData.desktops;
            in
            {
              command = "${pkgs.tuigreet}/bin/tuigreet --sessions ${desktops}/share/xsessions:${desktops}/share/wayland-sessions --remember --remember-user-session";
              user = "greeter";
            };
        };
      };

      # PAM configuration to allow greetd to manage user sessions and integrate with gnome-keyring:
      security.pam.services = {
        greetd = {
          enableGnomeKeyring = true;
          # When fprintd is active, place it after pam_unix so password works
          # without waiting for a swipe. Gate on services.fprintd.enable because
          # the fingerprint module may not be imported on fprintd-less hosts.
          rules.auth.fprintd.order = lib.mkIf config.services.fprintd.enable (
            config.security.pam.services.greetd.rules.auth.unix.order + 10
          );
        };
        login.enableGnomeKeyring = true;
      };
    };
}
