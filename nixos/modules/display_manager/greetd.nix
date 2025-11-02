{ config, pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session =
        let desktops = config.services.displayManager.sessionData.desktops;
        in {
          command =
            "${pkgs.tuigreet}/bin/tuigreet --sessions ${desktops}/share/xsessions:${desktops}/share/wayland-sessions --remember --remember-user-session";
          user = "greeter";
        };
    };
  };
}
