{
  flake.nixosModules.wayland =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wlr-randr # Get display information
        wdisplays # GUI for easy, one-time config
      ];
    };
}
