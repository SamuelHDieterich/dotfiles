{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    keybindings = [{
      # When keyboard is not properly configured, "/" key is read as ";"
      key = "ctrl+;";
      command = "editor.action.commentLine";
      when = "editorTextFocus && !editorReadonly";
    }];
    extensions = with pkgs.vscode-extensions; [
      github.copilot
      github.copilot-chat
      eamodio.gitlens
      pkief.material-icon-theme
      jnoortheen.nix-ide
    ];
  };
}
