{...}: {
  imports = [
    ./monitors.nix
    ./input.nix
    ./keybindings.nix
    ./animations.nix
    ./decoration.nix
    ./windowrules.nix
  ];
  wayland.windowManager.hyprland.enable = true;
}