{ inputs, pkgs, ... }: {
  imports = [
    ./monitors.nix
    ./hyprpaper.nix
    ./input.nix
    ./keybindings.nix
    ./animations.nix
    ./decoration.nix
    ./windowrules.nix
    ./autostart.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./plugins.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    systemd.variables = [ "--all" ];
    settings.env = [
      "NIXOS_OZONE_WL,1"
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "QT_QPA_PLATFORM,wayland"
    ];
  };
}
