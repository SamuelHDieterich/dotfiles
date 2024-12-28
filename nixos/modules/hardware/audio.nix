{ config, lib, pkgs, ... }:
with lib;
let cfg = config.audio;
in {
  options.audio = {
    pipewire = mkOption {
      type = types.bool;
      default = true;
      description = "Enable PipeWire as the audio server.";
    };
    pulseaudio = mkOption {
      type = types.bool;
      default = false;
      description = "Enable PulseAudio as the audio server.";
    };
  };

  config = {
    security.rtkit.enable = true;
  } // lib.mkIf cfg.pipewire {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulseaudio.enable = true;
      jack.enable = true;
    };
  } // lib.mkIf cfg.pulseaudio {
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };
}
