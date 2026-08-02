---
name: devenv-workflow
description: Working in a devenv.nix development shell — adding packages and languages, defining scripts and processes, wiring git hooks, and handling .env and direnv. Use when editing devenv.nix, when a project command isn't found, or when setting up a new project shell.
---

# devenv

Projects use [devenv](https://devenv.sh) for their development shell, activated by direnv on `cd`. The shell is defined in `devenv.nix`, with `devenv.yaml` for inputs and `devenv.lock` pinning them.

## Before anything else

Run `help` inside the shell. It prints every script the project defines with its description — the fastest way to learn what a repo can do.

If a command the project documents isn't found, you are outside the shell. Check that direnv has allowed the directory before concluding the command is missing.

### Creating it in a new project

`help` isn't built in. It's a self-describing script that reads `config.scripts` back out of the configuration, so it never goes stale as scripts are added:

```nix
scripts.help = {
  description = "List available scripts and their descriptions.";
  exec =
    let
      scriptHelpTable = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "${name}\t${value.description}") config.scripts
      );
    in
    ''
      echo "Available scripts:"
      cat <<'EOF' | ${pkgs.util-linuxMinimal}/bin/column -t -s "$(printf '\t')" | ${pkgs.gnused}/bin/sed 's/^/- /'
      ${scriptHelpTable}
      EOF
    '';
};
```

This needs `config`, `lib` and `pkgs` in the module signature. Two details matter: the heredoc is quoted (`<<'EOF'`) so the shell doesn't expand anything in a description, and `column` is referenced by store path rather than assumed on `PATH`.

Every other script then needs a `description`, or it shows up in the table with an empty column. That is the point — the table is the enforcement.

## Structure

```nix
{ config, lib, pkgs, ... }:
{
  packages = with pkgs; [
    opentofu # Terraform open-source fork
    terragrunt # Terraform wrapper
  ];

  languages.python = {
    enable = true;
    package = pkgs.python313; # Pin the interpreter
    uv.enable = true;
  };
}
```

Pin language versions explicitly rather than taking the default — the point of the shell is that everyone gets the same one. Every entry in `packages` gets a trailing `#` comment naming it.

## Scripts and processes

`scripts` are one-shot commands, always with a `description` so `help` can list them. `processes` are long-running services that `devenv up` starts together — a backend, a frontend dev server, a database.

Take ports from `config.processes.<name>.ports.server.value` rather than hardcoding them, so one service referring to another stays correct if a port moves.

## Environment

`dotenv.enable = true` loads static values from `.env`. Only variables needing Nix interpolation — paths under `config.devenv.state`, ports, values composed from other config — belong in `env`. Don't define the same variable in both places.

Bind development servers to `127.0.0.1`, not `localhost`. glibc resolves `localhost` to `::1` first, and tooling that assumes IPv4 will disagree about the address.

## Git hooks

`git-hooks.hooks.<name>.enable = true` wires pre-commit checks — `ruff` and `ruff-format` for Python, `nixfmt` for Nix. These run on commit, so a formatting failure at commit time is the hook working, not an obstacle to route around.

## Related

Nix module conventions for the dotfiles repo itself are a separate topic — see the `nix-dendritic` skill.
