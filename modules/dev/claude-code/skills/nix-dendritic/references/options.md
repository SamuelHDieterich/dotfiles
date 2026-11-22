# Module options

Most modules have no options. A host either imports the module or it doesn't, and that is the whole configuration surface. Reach for `options` only when one host needs the module configured *differently* from another, not to make it toggleable. Never add an `mkEnableOption`.

## Shape

```nix
{ inputs, ... }:
{
  flake.homeModules.shell =
    { config, lib, pkgs, ... }:
    with lib;
    {
      options.shell.include = mkOption {
        type = types.listOf (types.enum [ "bash" "zsh" "fish" "nushell" ]);
        default = [ "bash" ];
        description = "Additional shells to include in the configuration.";
      };

      imports = with inputs.self.homeModules; [ starship bash zsh fish nushell ];

      config = mkMerge [
        { /* always applied */ }
        (mkIf (builtins.elem "zsh" config.shell.include) { /* zsh only */ })
      ];
    };
}
```

Points worth copying:

- The option namespace is bare (`options.shell`, `options.keyboard`), not nested under `programs` or `services`. Those namespaces belong to upstream.
- Always give a `default` and a `description`.
- `types.enum` over a free-form string when the valid values are known: it turns a typo into an evaluation error instead of a silent no-op.
- `mkMerge` with `mkIf` branches, rather than one large conditional.

A host then sets it alongside its imports:

```nix
shell.include = [ "zsh" "nushell" ];
```

## Before designing a new option

Read the modules in the repo that already declare `options`, and match their conventions.
