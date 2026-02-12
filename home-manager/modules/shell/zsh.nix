{ config, lib, ... }: {

  imports = [ ./common.nix ];

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Get a Keystroke: CTRL+V + <key combination>
    initContent = lib.strings.concatStringsSep "\n" [
      # Copy current buffer to clipboard
      "cmd_to_clip () { wl-copy -n <<< $BUFFER }"
      "zle -N cmd_to_clip"
      "bindkey '^Y' cmd_to_clip"
      # Autocomplete: accept next word
      "bindkey '^[[Z' forward-word" # Shift + Tab
      "bindkey '^[[1;5C' forward-word" # Ctrl + Right Arrow
      "bindkey '^[[1;5D' backward-word" # Ctrl + Left Arrow
      # Delete word
      "bindkey '^H' backward-kill-word" # Ctrl + Backspace
      "bindkey '^[[3;5~' kill-word" # Ctrl + Delete
      # For a clean $HOME 
      "compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
      # Nix develop alias
      ''
        nix() {
          if [[ $1 == 'develop' ]]; then
            shift
            command nix develop -c $SHELL "$@"
          else
            command nix "$@"
          fi
        }
      ''
    ];
    shellAliases = config.shellAliases;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

}
