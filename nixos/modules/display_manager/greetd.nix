{ config, pkgs, ... }: {
  services.greetd = {
    enable = true;
    vt = 2; # Virtual terminal to use for greetd.
    settings = {
      default_session =
        let desktops = config.services.displayManager.sessionData.desktops;
        in {
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${desktops}/share/xsessions:${desktops}/share/wayland-sessions --remember --remember-user-session";
          user = "greeter";
        };
    };
  };
}
