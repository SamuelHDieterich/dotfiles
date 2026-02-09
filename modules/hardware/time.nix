{
  flake.nixosModules.time = {
    services.timesyncd.enable = true; # Enable systemd-timesyncd for time synchronization
  };
}
