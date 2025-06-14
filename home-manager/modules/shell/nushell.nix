{ ... }: {

  # imports = [ ./common.nix ];

  programs.nushell = {
    enable = true;
    # shellAliases = config.shellAliases; # Nushell is way different
    shellAliases = {
      # Nix
      nix-shell = "nix-shell --run $env.SHELL";
    };
  };

}
