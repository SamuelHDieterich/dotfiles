{
  flake.nixosModules.audio =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      cfg = config.audio;
    in
    {
      options.audio = {
        platform = mkOption {
          type = types.enum [
            "pipewire"
            "pulseaudio"
          ];
          default = "pipewire";
          description = "Select the audio platform to enable. Options are 'pipewire' and 'pulseaudio'. 'pipewire' is the default for modern systems, while 'pulseaudio' is provided for compatibility with older setups.";
        };
      };

      config = lib.mkMerge [
        {
          security.rtkit.enable = true;
          environment.systemPackages = with pkgs; [
            pavucontrol # PulseAudio volume control (also works with PipeWire)
          ];
        }
        (lib.mkIf (cfg.platform == "pipewire") {
          services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
          };
        })
        (lib.mkIf (cfg.platform == "pulseaudio") {
          hardware.pulseaudio = {
            enable = true;
            package = pkgs.pulseaudioFull;
          };
        })
      ];
    };
}
