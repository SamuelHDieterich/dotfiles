{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [ sensible vim-tmux-navigator ];
  };
}
