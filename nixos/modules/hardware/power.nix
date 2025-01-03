{ config, lib, ... }:
with lib;
let cfg = config.power;
in {
  options.power = {
    ac = mkOption {
      type = types.str;
      default = "performance";
      description = "The power profile for AC power.";
    };
    battery = mkOption {
      type = types.str;
      default = "balance";
      description = "The power profile for battery power.";
    };
  };

  config = {
    services.tlp = {
      enable = true;
      # settings = {
      #   CPU_SCALING_GOVERNOR_ON_AC = cfg.ac;
      #   CPU_SCALING_GOVERNOR_ON_BAT = "balance";

      #   CPU_ENERGY_PERF_POLICY_ON_AC = cfg.ac;
      #   CPU_ENERGY_PERF_POLICY_ON_BAT = "balance";

      #   CPU_MIN_PERF_ON_AC = 0;
      #   CPU_MAX_PERF_ON_AC = 100;
      #   CPU_MIN_PERF_ON_BAT = 0;
      #   CPU_MAX_PERF_ON_BAT = 100;

      #   CPU_BOOST_ON_AC = 1;
      #   CPU_BOOST_ON_BAT = 0;

      #   START_CHARGE_THRESH_BAT0 = 75;
      #   STOP_CHARGE_THRESH_BAT0 = 90;

      #   PLATFORM_PROFILE_ON_AC = cfg.ac;
      #   PLATFORM_PROFILE_ON_BAT = "balanced";
      # };
    };
  };
}
