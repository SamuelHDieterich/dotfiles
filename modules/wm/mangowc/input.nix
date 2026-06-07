{
  flake.homeModules.mangowc =
    {
      inputs,
      config,
      lib,
      ...
    }:
    with lib;
    {
      imports = [
      ];
      wayland.windowManager.mango.settings =
        let
          keyboard = config.keyboardValue;
        in
        {
          # Keyboard
          numlockon = 1; # Enable numlock on startup
          xkb_rules = mkMerge [
            { options = "grp:alt_shift_toggle"; }
            (mkIf (keyboard.layouts != null) { layout = keyboard.layouts; })
            (mkIf (keyboard.models != null) { model = keyboard.models; })
            (mkIf (keyboard.variants != null) { variant = keyboard.variants; })
          ];
          # Trackpad
          trackpad_natural_scrolling = false;
        };
    };
}
