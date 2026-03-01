{
  flake.nixosModules.games =
    { pkgs, ... }:
    {
      programs = {
        steam.enable = true; # Steam launcher
        gamemode.enable = true; # Performance optimization tool
      };

      environment.systemPackages = with pkgs; [
        lutris # Game manager
        mangohud # Monitoring overlay for games
        ruffle # Flash emulator for playing old Flash games
        zenity # RUffle dependency for file dialogs
      ];
    };
}
