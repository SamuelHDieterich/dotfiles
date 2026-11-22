{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { config, pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;

      pre-commit.settings.hooks.nixfmt.enable = true;

      devShells.default = pkgs.mkShell {
        inherit (config.pre-commit.devShell) shellHook;
        packages = with pkgs; [
          nixfmt # Nix formatter
          sops # Edits the encrypted secrets
          ssh-to-age # Turns a host's SSH key into its age recipient
          nixos-anywhere # Installs NixOS on a machine over SSH
          nh # Nix helper for rebuilds
        ];
      };
    };
}
