{
  flake.homeModules.theme =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        hyprcursor.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 20;
      };
      xdg.enable = true;
      gtk = {
        enable = true;
        theme = {
          package = pkgs.juno-theme;
          name = "Juno-ocean";
        };
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
      };
      dconf = {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      };
    };
}
