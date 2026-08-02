# Samuel's Global Context

Data engineer. Master's student in microelectronics, researching fault detection in electronic circuits with neural networks. Academic writing uses Typst, not LaTeX; bibliography in Zotero.

Strong interest in Rust, systems programming and high-performance code — treat work in that direction as something I want to understand, not just receive.

## Machine

NixOS, configured as a dendritic flake (flake-parts + import-tree + flake-file) at `~/dotfiles`. Home-manager for user config, Podman for containers, foot as terminal, Neovim and VS Code as editors.

Modules are auto-discovered from `modules/`; a host opts in by adding the module name to its `imports` list in `hosts/<host>/configuration.nix`. Hosts are named after scientists — `turing` is the work laptop, `tesla` the personal one.

**I run system rebuilds myself.** Stage the config changes and tell me what to run; don't run `nixos-rebuild`, `nh os switch` or `nh home switch` for me.

## Languages

Python is primary, then SQL, Nix and Bash. Infrastructure is OpenTofu wrapped in Terragrunt, deployed to GCP.

Frontend work shows up in projects I maintain, but TypeScript and React are not my strength — when you touch them, keep the explanation grounded rather than assuming I'll spot a mistake.

Per-language conventions live in `~/.claude/rules/`. The deeper guides are skills — invoke `python-stack`, `nix-dendritic`, `devenv-workflow` or `terraform` when you need them.

## Working style

Declarative over imperative: if something can live in a Nix module, it should. Explicit over implicit. Readable over clever.

Commit messages use gitmoji — see the `git` rule.
