{
  flake.nixosModules.greetd =
    { config, pkgs, ... }:
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
        gretd.enableGnomeKeyring = true;
        gretd-password.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
    };
}
