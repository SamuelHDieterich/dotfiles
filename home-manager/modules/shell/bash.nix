{ config, lib, ... }: {

  imports = [ ./common.nix ];

  programs.bash = {
    enable = true;
    # Get a Keystroke: CTRL+V + <key combination>
    initExtra = lib.strings.concatStringsSep "\n" [
      # Copy current buffer to clipboard
      ''cmd_to_clip () { wl-copy -n <<< "$READLINE_LINE"; }''
      "export -f cmd_to_clip"
      "bind -x '\"C-y\":cmd_to_clip'"
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
    shellAliases = config.shellAliases;
  };

}
