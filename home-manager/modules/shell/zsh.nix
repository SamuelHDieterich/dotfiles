{
  config,
  pkgs,
  lib,
  ...
}: {

  home.packages = with pkgs; [
    eza
    wl-clipboard
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = lib.concatStrings [
      # Copy current buffer to clipboard
      "
      cmd_to_clip () { wl-copy -n <<< $BUFFER }
      zle -N cmd_to_clip
      bindkey '^Y' cmd_to_clip
      "
      # Autocomplete: accept next word
      "bindkey '^[[Z' forward-word"
      "bindkey '^[[1;5C' forward-word"
    ];
    shellAliases = {
      ls = "eza --icons=always --color";
      ll = "ls -l";
    };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
