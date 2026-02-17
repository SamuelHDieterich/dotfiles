let
  sessionVariables = xdg: {
    ZDOTDIR = "${xdg.configHome}/zsh";
    HISTFILE = "${xdg.stateHome}/zsh/history";
    CARGO_HOME = "${xdg.dataHome}/cargo";
    DOTNET_CLI_HOME = "${xdg.dataHome}/dotnet";
    ECLIPSE_HOME = "${xdg.dataHome}/eclipse";
    GNUPGHOME = "${xdg.dataHome}/gnupg";
    CUDA_CACHE_PATH = "${xdg.cacheHome}/nv";
    GTK2_RC_FILES = "${xdg.configHome}/gtk-2.0/gtkrc";
    XCOMPOSECACHE = "${xdg.cacheHome}/X11/xcompose";
  };
in
{
  flake.nixosModules.sessionVariables =
    { lib, ... }:
    let
      xdg = {
        configHome = "$HOME/.config";
        stateHome = "$HOME/.local/state";
        dataHome = "$HOME/.local/share";
        cacheHome = "$HOME/.cache";
      };
    in
    {
      environment.sessionVariables = lib.mkMerge [
        {
          XDG_CACHE_HOME = xdg.cacheHome;
          XDG_CONFIG_HOME = xdg.configHome;
          XDG_DATA_HOME = xdg.dataHome;
          XDG_STATE_HOME = xdg.stateHome;
        }
        (sessionVariables xdg)
      ];
    };

  flake.homeModules.sessionVariables =
    { config, ... }:
    {
      home.sessionVariables = sessionVariables config.xdg;
    };
}
