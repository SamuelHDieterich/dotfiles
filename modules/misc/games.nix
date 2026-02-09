{
  flake.nixosModules.games =
    { pkgs, ... }:
    {
      programs = {
        steam.enable = true; # Steam launcher
        # lutris.enable = true; # Lutris game manager
        gamemode.enable = true; # Performance optimization tool
        # mangohud.enable = true; # Monitoring overlay for games
      };

      environment.systemPackages = with pkgs; [
        ruffle # Flash emulator for playing old Flash games
      ];
    };
}
