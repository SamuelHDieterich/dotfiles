{
  flake.nixosModules.tailscale = {
    services.tailscale.enable = true;
  };

  flake.homeModules.tailscale = {
    services.tailscale-systray.enable = true;
  };
}
