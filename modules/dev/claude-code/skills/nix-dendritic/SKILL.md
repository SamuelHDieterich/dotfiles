---
name: nix-dendritic
description: Authoring modules in the dendritic dotfiles flake — flake-parts with import-tree and flake-file, declaring homeModules and nixosModules, adding flake inputs, wiring a host, and adding options when a knob is genuinely needed. Use when editing anything under ~/dotfiles, adding a new module, or adding a flake input.
---

# The dendritic dotfiles flake

`~/dotfiles` composes three pieces:

- **flake-parts** — the module system for the flake outputs themselves.
- **[`vic/import-tree`](https://github.com/vic/import-tree)** — auto-imports every `.nix` file under `hosts/`, `modules/` and `packages/` as a flake-parts module. There is no aggregator to register a new file in; dropping it in is enough.
- **[`vic/flake-file`](https://github.com/vic/flake-file)** — generates `flake.nix` from `flake-file.inputs` declarations scattered across the tree.

## flake.nix is generated

The header says so. Editing it directly is always wrong — the next `write-flake` run discards the edit.

To add an input, put it in the `inputs.nix` nearest the module that uses it, then regenerate:

```nix
# modules/dev/inputs.nix
{
  flake-file.inputs.devenv = {
    url = "github:cachix/devenv";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

```console
$ nix run .#write-flake
```

Always `follows` nixpkgs unless there's a specific reason not to. The flake has one nixpkgs — `nixos-unstable` — and no stable channel.

## Declaring a module

A module file declares a named output and nothing else. There is no `mkEnableOption` anywhere in this repo, and adding one would be off-convention: a host opts out by not importing the module.

```nix
{
  flake.homeModules.git = {
    programs = {
      git.enable = true;
      lazygit.enable = true; # TUI for Git
      gh.enable = true; # GitHub CLI
    };
  };
}
```

`flake.homeModules.<name>` for user config, `flake.nixosModules.<name>` for system config. Compound names are camelCase — `waybarMangoOverlay`, `nonNixos`, `claudeCode`.

Modules taking arguments receive `inputs` and the usual module args, because both host paths pass `specialArgs = { inherit inputs; }`:

```nix
{
  flake.homeModules.foo =
    { pkgs, inputs, ... }:
    { ... };
}
```

## Directory modules

When a module outgrows one file, split it across a directory. Every file declares the *same* module name and flake-parts merges them — see `modules/wm/mangowc/`, where `default.nix`, `bindings.nix`, `autostart.nix` and the rest each declare `flake.homeModules.mangowc`.

Non-Nix assets sit beside the Nix files and are referenced by relative path: `style = ./style.css;`, `text = builtins.readFile ./screens.sh;`.

## Wiring a host

Hosts explicitly opt in. In `hosts/<host>/configuration.nix`:

```nix
imports = with inputs.self.homeModules; [
  git # Git configuration
  devenv # Development environment with nix
];
```

Each host file defines four attributes — `nixosConfigurations.<host>`, `homeConfigurations.<host>`, `nixosModules.<host>` and `homeModules.<host>` — with a `let` block holding `system`, `stateVersion`, `username`, `hostname` and `bundles`.

Watch the spelling: `modules/dev/vscode.nix` declares `flake.homeManager.vscode` instead of `flake.homeModules.vscode`, so that module is silently dead. A typo here produces no error, just a module nobody imports.

## Config files

Strongly prefer upstream `programs.*` and `services.*` options over writing files yourself. This repo has no `home.file` and no `mkOutOfStoreSymlink`; everything is store-managed. When there is no upstream option, `xdg.configFile."path".text` or `.source` is the fallback.

## Further reading

- `references/options.md` — the shape to use when a module genuinely needs a knob.
- `references/overlays.md` — overlays, package overrides and the standalone-home-manager caveat.
