{ inputs, ... }:
{
  flake.homeModules.shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      shellAliases = {
        # Nix
        nix-shell = "nix-shell --run $SHELL";
        # List commands
        ls = "eza --icons=always --color=always";
        ll = "ls -l";
        lt = "ls --tree";
        # Git
        gs = "git status";
        gc = "git commit";
        gw = "git worktree";
      };
    in
    with lib;
    {
      options.shell = {
        include = mkOption {
          type = types.listOf (
            types.enum [
              "bash"
              "zsh"
              "fish"
              "nushell"
            ]
          );
          default = [ "bash" ];
          description = "Additional shells to include in the configuration.";
        };
      };

      imports = with inputs.self.homeModules; [
        starship # Shell prompt
        # Available shells
        bash
        zsh
        fish
        nushell
      ];

      config = mkMerge [
        {
          home.packages = with pkgs; [
            eza
            wl-clipboard
          ];
          programs = {
            zoxide.enable = true;
            atuin.enable = true;
            fzf.enable = true;
            direnv.enable = true;
          };
        }
        (mkIf (builtins.elem "bash" config.shell.include) {
          programs.bash = {
            enable = true;
            shellAliases = shellAliases;
          };
        })
        (mkIf (builtins.elem "zsh" config.shell.include) {
          programs.zsh = {
            enable = true;
            shellAliases = shellAliases;
          };
        })
        (mkIf (builtins.elem "fish" config.shell.include) {
          programs.fish = {
            enable = true;
            shellAliases = shellAliases;
          };
        })
        (mkIf (builtins.elem "nushell" config.shell.include) {
          programs.nushell = {
            enable = true;
            # Different alias syntax for nushell
          };
        })
      ];
    };
}
