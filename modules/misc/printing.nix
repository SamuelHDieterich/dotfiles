{
  flake.nixosModules.printing =
    { pkgs, ... }:
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
        extraBackends = [ pkgs.epkowa ];
      };

      # Helpful tools for printer and scanner configuration
      environment.systemPackages = with pkgs; [
        system-config-printer # Printer configuration tool
        simple-scan # Simple scanning application
      ];
    };
}
