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
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
  };
}
