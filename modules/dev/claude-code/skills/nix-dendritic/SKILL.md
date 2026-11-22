---
name: nix-dendritic
description: Use when authoring modules in a dendritic Nix flake (flake-parts with import-tree and flake-file) — declaring homeModules or nixosModules, adding a flake input, wiring a host, or adding a module option.
---

# Dendritic Nix flakes

A dendritic flake composes three pieces:

- **flake-parts** — the module system for the flake outputs themselves.
- **[`vic/import-tree`](https://github.com/vic/import-tree)** — auto-imports every `.nix` file under the listed directories as a flake-parts module. There is no aggregator to register a new file in; dropping it in is enough.
- **[`vic/flake-file`](https://github.com/vic/flake-file)** — generates `flake.nix` from `flake-file.inputs` declarations scattered across the tree.

Every file is a flake-parts module, whatever it configures. A file that configures a NixOS system or a home-manager user does so by declaring a named module output.

## flake.nix is generated

Its header says so. Editing it directly is always wrong: the next `write-flake` run discards the edit.

To add an input, declare it in an `inputs.nix` beside the modules that use it, then regenerate:

```nix
{
  flake-file.inputs.foo = {
    url = "github:example/foo";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

```console
$ nix run .#write-flake
```

Make every input `follows` nixpkgs unless there's a specific reason not to. Check `flake.lock` afterwards for duplicate copies of a transitive input, and add a `follows` for each one.

## Declaring a module

A module file declares a named output and nothing else. Hosts opt in by importing the module and opt out by not importing it, so modules carry no `mkEnableOption`.

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

`flake.homeModules.<name>` holds user config and `flake.nixosModules.<name>` holds system config. Compound names are camelCase (`fooBar`).

Modules that need flake inputs take them from the file's outer `{ inputs, ... }:` and close over them. With no `specialArgs` or `extraSpecialArgs` in the hosts, an `inputs` argument on the inner module function is never supplied:

```nix
{ inputs, ... }:
{
  flake.homeModules.foo =
    { pkgs, ... }:
    { home.packages = [ inputs.bar.packages.${pkgs.stdenv.hostPlatform.system}.default ]; };
}
```

The output attribute name is not type-checked. A typo such as `flake.homeManager.foo` evaluates without error and creates a module nobody imports.

## Directory modules

When a module outgrows one file, split it across a directory. Every file declares the *same* module name and flake-parts merges them: `default.nix`, `bindings.nix` and `autostart.nix` can each declare `flake.homeModules.foo`.

Non-Nix assets sit beside the Nix files and are referenced by relative path: `style = ./style.css;`, `text = builtins.readFile ./script.sh;`.

## Wiring a host

A host is a flake-parts module too. It builds its system from the modules it names:

```nix
{ inputs, ... }:
{
  flake.nixosConfigurations.foo = inputs.nixpkgs.lib.nixosSystem {
    modules = [ inputs.self.nixosModules.foo ];
  };

  flake.nixosModules.foo = {
    imports = with inputs.self.nixosModules; [
      base # Users, locale and nix settings
      ssh # OpenSSH server
    ];
  };
}
```

Facts shared by several hosts (SSH public keys, say) are flake-level options declared in a flake-parts module. Read them from the host file's outer `{ config, ... }:` argument and pass them into the NixOS module by closure, as `inputs` is.

## Config files

Strongly prefer upstream `programs.*` and `services.*` options over writing files yourself. When there is no upstream option, `xdg.configFile."path".text` or `.source` is the fallback.

## Further reading

- `references/options.md` — the shape to use when a module genuinely needs a knob.
- `references/overlays.md` — overlays, package overrides, local packages and the standalone-home-manager caveat.
