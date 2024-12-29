{ config, pkgs, lib, ... }: {

  home.packages = with pkgs; [ eza wl-clipboard ];

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Get a Keystroke: CTRL+V + <key combination>
    initExtra = lib.strings.concatStringsSep "\n" [
      # Copy current buffer to clipboard
      "cmd_to_clip () { wl-copy -n <<< $BUFFER }"
      "zle -N cmd_to_clip"
      "bindkey '^Y' cmd_to_clip"
      # Autocomplete: accept next word
      "bindkey '^[[Z' forward-word"
      "bindkey '^[[1;5C' forward-word"
      "bindkey '^[[1;5D' backward-word"
      # For a clean $HOME 
      "compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
      # Nix develop alias
      ''
        nix() {
          if [[ $1 == 'develop' ]]; then
            shift
            command nix develop -c $SHELL '$@'
          else
            command nix $@
          fi
        }
      ''
    ];
    shellAliases = {
      ls = "${lib.getExe pkgs.eza} --icons=always --color=always";
      ll = "ls -l";
      lt = "ls --tree";
      nix-shell = "nix-shell --run $SHELL";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  programs = {
    zoxide.enable = true;
    atuin.enable = true;
    fzf.enable = true;
  };
}
