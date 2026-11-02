{
  flake.nixosModules.games =
    { pkgs, ... }:
    let
      # Lutris hardcodes gtk2 in its FHS env, and evaluation refuses it as broken ahead of removal in NixOS 27.05.
      # Match on pname because comparing derivations would force gtk2 and trigger the refusal.
      # https://github.com/NixOS/nixpkgs/issues/410814
      lutrisWithoutGtk2 = pkgs.lutris.override {
        buildFHSEnv =
          args:
          pkgs.buildFHSEnv (
            args
            // {
              multiPkgs = fhsPkgs: builtins.filter (pkg: (pkg.pname or "") != "gtk+") (args.multiPkgs fhsPkgs);
            }
          );
      };
    in
    {
      programs = {
        steam.enable = true; # Steam launcher
        gamemode.enable = true; # Performance optimization tool
      };

      environment.systemPackages = with pkgs; [
        lutrisWithoutGtk2 # Game manager
        mangohud # Monitoring overlay for games
        ruffle # Flash emulator for playing old Flash games
        zenity # RUffle dependency for file dialogs
      ];
    };
}
