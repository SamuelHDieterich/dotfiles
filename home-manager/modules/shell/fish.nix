{ config, ... }: {

  imports = [ ./common.nix ];

  programs.fish = {
    enable = true;
    shellAliases = config.shellAliases;
  };

}
