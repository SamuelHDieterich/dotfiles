{
  flake.nixosModules.printing =
    { pkgs, ... }:
    let
      # Evaluation refuses gtk2 as broken, and iscan's configure demands it even though --disable-frontend means nothing links it.
      # Setting the GTK variables skips that pkg-config check.
      # https://github.com/NixOS/nixpkgs/issues/410814
      epkowaWithoutGtk2 = pkgs.epkowa.overrideAttrs (old: {
        buildInputs = builtins.filter (pkg: (pkg.pname or "") != "gtk+") old.buildInputs;
        GTK_CFLAGS = " ";
        GTK_LIBS = " ";
      });
    in
    {
      services = {
        printing = {
          enable = true;
          drivers = [ pkgs.epson_201207w ];
        };
        # Support for wireless printers
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };
      };
      # Support for scanners
      hardware.sane = {
        enable = true;
        openFirewall = true;
        extraBackends = [ epkowaWithoutGtk2 ];
      };

      # Helpful tools for printer and scanner configuration
      environment.systemPackages = with pkgs; [
        system-config-printer # Printer configuration tool
        simple-scan # Simple scanning application
      ];
    };
}
