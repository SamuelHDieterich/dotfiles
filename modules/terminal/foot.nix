{
  flake.homeModules.foot =
    { lib, pkgs, ... }:
    {
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            term = "xterm-256color"; # Use a more compatible TERM value
            include = "${pkgs.foot.themes}/share/foot/themes/kitty";
            font = "JetBrainsMono Nerd Font Mono:size=10";
            initial-window-mode = "maximized"; # Useful for non-tiling WMs
            pad = "5x5 center-when-maximized-and-fullscreen";
          };
          csd.preferred = "none"; # Disable window decorations
        };
      };

      # Make foot the default terminal emulator
      xdg.terminal-exec = {
        enable = true;
        settings.default = lib.mkDefault [ "footclient.desktop" ];
      };
    };
}
