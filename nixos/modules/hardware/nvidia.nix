{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.nvidia;
in {
  options.nvidia = {
    package = mkOption {
      type = types.str;
      default = "stable";
      description = "The NVIDIA driver package to use: stable or beta.";
    };
    open = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the open-source driver version.";
    };
    powerManagement = mkOption {
      type = types.bool;
      default = true;
      description = "Enable power management for the NVIDIA GPU.";
    };
    prime = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable NVIDIA PRIME for hybrid graphics.";
      };
      renderOffload = mkOption {
        type = types.bool;
        default = true;
        description = "Enable NVIDIA PRIME render offload.";
      };
      busId = {
        intel = mkOption {
          type = types.str;
          description = "The PCI bus ID of the Intel GPU.";
        };
        nvidia = mkOption {
          type = types.str;
          description = "The PCI bus ID of the NVIDIA GPU.";
        };
      };
    };
  };

  config = {
    # Enable OpenGL
    hardware.graphics.enable = true;

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # Modesetting is required
      modesetting.enable = true;

      powerManagement.enable = cfg.powerManagement;
      powerManagement.finegrained = cfg.powerManagement;

      prime = mkIf cfg.prime.enable {
        offload = mkIf cfg.prime.renderOffload {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = cfg.prime.busId.intel;
        nvidiaBusId = cfg.prime.busId.nvidia;
      };

      nvidiaSettings = true;

      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.package};
    };
  };
}
