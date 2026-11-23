{
  flake.nixosModules.alwaysOn = {
    # Disabling the targets, rather than logind's actions, also stops a future desktop session from suspending the machine.
    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };
}
