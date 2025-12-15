{ ... }: {
  imports = [
    ./monitors.nix
    ./hyprpaper.nix
    ./input.nix
    ./keybindings.nix
    ./animations.nix
    ./decoration.nix
    ./windowrules.nix
    ./autostart.nix
    ./hyprlock.nix
    ./hypridle.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
  };
}
