# Builds the Neovim config as a standalone package (`nix run .#nvim`) and installs it through home-manager.
{ inputs, ... }:
{
  imports = [ inputs.nixvim.flakeModules.default ];

  # Turn every nixvimConfiguration into `packages.<name>`, plus a startup test at `checks.<name>`.
  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  perSystem =
    { system, ... }:
    {
      nixvimConfigurations.nvim = inputs.nixvim.lib.evalNixvim {
        inherit system;
        modules = [
          inputs.self.nixvimModules.neovim
          # Build from this flake's nixpkgs; without it nixvim warns about the `follows` and the startup check fails
          { nixpkgs.source = inputs.nixpkgs; }
        ];
      };
    };

  flake.homeModules.neovim =
    { lib, pkgs, ... }:
    let
      nvim = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvim;
    in
    {
      home.packages = [
        nvim # IDE-like Neovim built by nixvim
      ];
      home.sessionVariables.EDITOR = lib.getExe nvim;
    };
}
