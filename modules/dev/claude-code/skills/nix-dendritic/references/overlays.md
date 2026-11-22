# Overlays and package overrides

## Where overlays go

Overlays are applied inside a *NixOS* module via `nixpkgs.overlays`, not at flake level:

```nix
{
  flake.nixosModules.fooOverlay = {
    nixpkgs.overlays = [
      (final: prev: { foo = /* ... */; })
    ];
  };
}
```

The host then imports that module by name like any other.

## The standalone home-manager caveat

A repo may define a host's user config twice: inside `nixosConfigurations.<host>` (home-manager as a NixOS module) and as `homeConfigurations.<host>` (standalone, driven by `nh home switch`).

The standalone path builds from `inputs.nixpkgs.legacyPackages.${system}` directly, so **`nixpkgs.overlays` set in a NixOS module does not reach it**. A package override that must apply to both paths belongs in the home module, using an explicit `pkgs.<name>.override` or a package from `inputs.self.packages`.

## Overlays are temporary by default

An overlay opens with a comment saying why it exists and when to delete it:

```nix
# TEMPORARY
# foo's bar module was added upstream on 2026-01-15 but has not shipped in a tagged release yet.
# Build from a post-bar master commit until a release includes it, then delete this module and its host imports.
# https://github.com/example/foo/commit/abc1234
```

This is the exception to keeping comments short. An overlay encodes a claim about upstream state that nothing in the code can express, and without the deletion condition it outlives its reason. Include the upstream commit, issue or PR link.

The same applies to individual `override` arguments — say what breaks without each one, so a future reader can test whether it is still needed.

## Local packages

Packages built in the flake itself are declared with `perSystem`:

```nix
{
  perSystem = { pkgs, ... }: {
    packages.foo = pkgs.stdenv.mkDerivation { /* ... */ };
  };
}
```

Consume them as `inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.foo`.
