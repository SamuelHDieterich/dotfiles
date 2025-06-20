{ config, lib, pkgs, ... }:
with lib;
with types; {
  options = {
    shellAliases = mkOption {
      type = attrsOf str;
      description = "Common shell aliases for various commands.";
    };
  };

  config = {
    home.packages = with pkgs; [ eza wl-clipboard ];
    shellAliases = {
      # Nix
      nix-shell = "nix-shell --run $SHELL";
      # List commands
      ls = "${lib.getExe pkgs.eza} --icons=always --color=always";
      ll = "ls -l";
      lt = "ls --tree";
      # Git
      gs = "git status";
      gc = "git commit";
      gw = "git worktree";
    };
    programs = {
      zoxide.enable = true;
      atuin.enable = true;
      fzf.enable = true;
    };
  };
}
