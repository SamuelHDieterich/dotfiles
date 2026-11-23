{
  flake.nixosModules.lovelace = {
    hardware.facter = {
      reportPath = ./facter.json;
      detected = {
        # facter turns graphics on whenever a monitor was attached during the report.
        graphics.enable = false;
        # NetworkManager (from base) manages the links; facter would add dhcpcd on each interface too.
        dhcp.enable = false;
      };
    };
  };
}
