{
  flake.nixosModules.thunar =
    { pkgs, ... }:
    {
      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-media-tags-plugin
          thunar-volman
        ];
      };
      environment.systemPackages = with pkgs; [ file-roller ];
    };

  # Thunar's "Open Terminal Here" goes through exo,
  # which only understands the legacy helpers.rc preference and hardcodes xfce4-terminal as its fallback.
  flake.homeModules.thunar =
    { config, lib, ... }:
    let
      terminals = config.xdg.terminal-exec.settings.default or [ ];
    in
    {
      xdg.configFile."xfce4/helpers.rc" = lib.mkIf (terminals != [ ]) {
        text = ''
          TerminalEmulator=${lib.removeSuffix ".desktop" (lib.head terminals)}
        '';
      };
    };
}
