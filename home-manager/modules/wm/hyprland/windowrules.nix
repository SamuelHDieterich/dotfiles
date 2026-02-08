{ ... }: {
  wayland.windowManager.hyprland.settings.windowrule = [
    # Ignore maximize requests from apps. You'll probably like this.
    "suppress_event maximize, match:class .*"

    # Fix some dragging issues with XWayland
    "no_focus on, match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false"
  ];
}
