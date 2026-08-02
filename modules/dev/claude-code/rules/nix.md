---
paths:
  - "**/*.nix"
---

# Nix

`~/dotfiles` is a dendritic flake: flake-parts, `import-tree` and `flake-file`. Every `.nix` file under `hosts/`, `modules/` and `packages/` is auto-imported as a flake-parts module.

**`flake.nix` is generated.** Never edit it. Declare inputs in the nearest `inputs.nix` under `flake-file.inputs`, then run `nix run .#write-flake` to regenerate.

Modules declare `flake.homeModules.<name>` or `flake.nixosModules.<name>` with plain config. There are no `enable` flags — a host opts out by not importing the module. Compound names are camelCase (`waybarMangoOverlay`, `claudeCode`).

A directory module splits across files: each file declares `flake.homeModules.<sameName>` and flake-parts merges them. See `modules/wm/mangowc/`.

Every entry in a package list gets a trailing `#` comment naming what it is.

Prefer upstream `programs.*` / `services.*` options over writing files by hand. This repo has no `home.file` and no `mkOutOfStoreSymlink` — keep it that way.

I run the rebuild. Stage the change and tell me the command; don't run `nixos-rebuild`, `nh os switch` or `nh home switch`.

For the module patterns and host wiring in depth, invoke the `nix-dendritic` skill.
