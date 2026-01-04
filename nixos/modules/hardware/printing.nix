{ pkgs, ... }:
let
  epkowa_fixed = pkgs.epkowa.overrideAttrs (oldAttrs: {
    configureFlags = (oldAttrs.configureFlags or [ ])
      ++ [ "CFLAGS=-std=gnu17" ];
  });
in {
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
    extraBackends = [ epkowa_fixed ];
  };
}
