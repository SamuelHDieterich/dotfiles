{ inputs, ... }:
{
  flake.nixosModules.mangowc =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.mangowc.nixosModules.mango
        inputs.self.nixosModules.wayland
      ];
      programs.mango.enable = true;

      # hyprlock is the screen locker for all mangowc hosts. Without an explicit
      # PAM service it falls back to the deny-all "other" stack, making password
      # unlock fail (only the fprintd D-Bus path works). Define it here so both
      # password and fingerprint unlock work regardless of fprintd being enabled.
      security.pam.services.hyprlock = {
        enableGnomeKeyring = true;
        # When fprintd is active, place it after pam_unix so password unlock
        # works without waiting for a swipe (mirrors fingerprint.passwordFirst).
        # Gate on services.fprintd.enable rather than fingerprint.passwordFirst
        # because the fingerprint module may not be imported on fprintd-less hosts.
        rules.auth.fprintd.order = lib.mkIf config.services.fprintd.enable (
          config.security.pam.services.hyprlock.rules.auth.unix.order + 10
        );
      };
    };

  flake.homeModules.mangowc = {
    imports = with inputs.self.homeModules; [
      inputs.mangowc.hmModules.mango
      hyprlock
      hypridle
    ];
    wayland.windowManager.mango = {
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      # This should be a temporary workaround
      autostart_sh = "dbus-update-activation-environment --systemd --all";
    };
  };
}
