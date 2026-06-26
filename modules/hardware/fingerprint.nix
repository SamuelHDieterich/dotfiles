# Fingerprint login does not auto-unlock secret keystores (keyring, wallet, etc.)
# because they are encrypted with the login password, which a fingerprint scan
# never supplies. To work around this, blank the keystore's own password —
# it will then unlock automatically on any login, relying on full-disk encryption
# for protection instead.
{ ... }:
{
  flake.nixosModules.fingerprint =
    { config, lib, ... }:
    {
      options.fingerprint.passwordFirst = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          When true, the password is tried before the fingerprint reader.
          Leaving the password field empty and pressing Enter triggers the swipe.
          When false, the fingerprint reader is tried first (default fprintd behavior).
        '';
      };

      config = {
        services.fprintd.enable = true;

        # Move pam_fprintd to just after pam_unix so password is tried first.
        # These services are environment-independent (always present on any host).
        # Greeter and locker services apply their own reorder in their own modules.
        security.pam.services = lib.mkIf config.fingerprint.passwordFirst (
          lib.genAttrs [ "login" "sudo" "su" "polkit-1" ] (name: {
            rules.auth.fprintd.order = config.security.pam.services.${name}.rules.auth.unix.order + 10;
          })
        );
      };
    };
}
