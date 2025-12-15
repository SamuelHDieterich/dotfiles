{ inputs, system, ... }: {
  imports = [ inputs.hyprdynamicmonitors.homeManagerModules.default ];

  home.hyprdynamicmonitors = {
    enable = true;
    installExamples = false;
  };
  home.packages = [ inputs.hyprdynamicmonitors.packages.${system}.default ];
  wayland.windowManager.hyprland.extraConfig = ''
    # Source the auto-generated monitors configuration
    source = ~/.config/hypr/monitors.conf
  '';

  # wayland.windowManager.hyprland.settings.monitor = [
  #   "eDP-1, preferred, auto, 1"
  #   "HDMI-A-1, preferred, auto-left, 1"
  #   "DP-1, preferred, auto-right, 1"
  # ];
}
