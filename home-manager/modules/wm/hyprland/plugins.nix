{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings.plugin = {
      "split-monitor-workspaces" = {
        count = 9;
        keep_focused = 1;
        enable_notifications = 0;
        enable_persistent_workspaces = 1;
      };
    };
  };
}
