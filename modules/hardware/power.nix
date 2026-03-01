{
  flake.nixosModules.power =
    { config, lib, ... }:
    {
      powerManagement = {
        enable = true; # Enable power management
        powertop.enable = true; # Power management and optimization
      };

      services = {
        # https://linrunner.de/tlp
        tlp = {
          enable = true;
          pd.enable = true; # power-rofiles-daemon like DBus interface for TLP
          settings = {
            # CPU governor:
            ## performance: maximum performance, no power saving
            ## powersave: maximum power saving, no performance
            ## schedutil: dynamic, based on scheduler load (default for many distros)
            ## ondemand: dynamic, based on CPU load (older, less efficient)
            ## conservative: dynamic, like ondemand but more gradual scaling

            # CPU energy performance policy (if supported):
            ## performance: maximum performance, no power saving
            ## balance_performance: balanced performance with some power saving
            ## default: use the default policy (usually balanced)
            ## balance_power: balanced power saving with some performance
            ## power: maximum power saving, reduced performance (if supported)

            # Platform profile:
            ## performance: maximum performance, no power saving
            ## balanced: balanced performance and power saving
            ## low-power: maximum power saving, reduced performance (if supported)

            # PCIe ASPM (Active State Power Management):
            ## default: use the default ASPM policy
            ## performance: ASPM disabled for maximum performance
            ## powersave: ASPM enabled for power saving
            ## powersupersave: aggressive ASPM for maximum power saving

            # SATA link power management:
            ## max_performance: SATA links are always active (no power saving)
            ## medium_power: SATA links can enter a low-power state when idle
            ## med_power_with_dipm: like medium_power but with aggressive power saving (recommended, kernel >= 4.15 required)
            ## min_power: SATA links can enter the lowest power state when idle

            # Performance on AC
            CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
            CPU_ENERGY_PERF_POLICY_ON_AC = "default";
            CPU_MIN_PERF_ON_AC = 0;
            CPU_MAX_PERF_ON_AC = 100;
            CPU_BOOST_ON_AC = 1;
            SCHED_POWERSAVE_ON_AC = 0;
            PLATFORM_PROFILE_ON_AC = "balanced";
            PCIE_ASPM_ON_AC = "default";
            SATA_LINKPWR_ON_AC = "med_power_with_dipm";
            RUNTIME_PM_ON_AC = "auto"; # Runtime PM: lets devices suspend when idle.
            WIFI_PWR_ON_AC = "off"; # Wi-Fi power save off

            # Battery life on BAT
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            CPU_MIN_PERF_ON_BAT = 0;
            CPU_MAX_PERF_ON_BAT = 70; # Reduce max performance on battery to save power and reduce heat
            CPU_BOOST_ON_BAT = 0;
            SCHED_POWERSAVE_ON_BAT = 1;
            PLATFORM_PROFILE_ON_BAT = "low-power";
            PCIE_ASPM_ON_BAT = "powersupersave";
            SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
            RUNTIME_PM_ON_BAT = "auto"; # Runtime PM: lets devices suspend when idle.
            WIFI_PWR_ON_BAT = "on"; # Wi-Fi power save on

            # Devices
            USB_AUTOSUSPEND = 1; # Suspend idle USB

            # Battery care
            START_CHARGE_THRESH_BAT0 = 75; # Start charging below
            STOP_CHARGE_THRESH_BAT0 = 90; # Stop charging at
          };
        };
        upower.enable = true;
      };
    };
}
