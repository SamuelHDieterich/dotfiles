{ config, lib, ... }:
{
  # nix flake check only evaluates configurations; these make it build them.
  # Each laptop's home-manager config is built inside its nixos toplevel; the standalone homeConfigurations are not checked.
  perSystem =
    { system, ... }:
    let
      onSystem = lib.filterAttrs (_: c: c.pkgs.stdenv.hostPlatform.system == system);
      nixos = lib.mapAttrs' (
        name: host: lib.nameValuePair "${name}-nixos" host.config.system.build.toplevel
      ) (onSystem config.flake.nixosConfigurations);
    in
    {
      checks = nixos;
    };
}
