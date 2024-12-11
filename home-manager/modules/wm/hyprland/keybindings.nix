{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    hyprlock
    fuzzel
    wireplumber
    brightnessctl
    playerctl
    kitty
    firefox
    vscode
    bemoji
  ];

  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$dmenu" = "fuzzel";
    "$terminal" = "kitty";
    "$browser" = "firefox";
    bind = [
      # General system
      "$mod, C, killactive"
      "$mod, delete, exit"
      "$mod, F, fullscreen"
      "$mod, space, togglefloating"
      "$mod, L, exec, hyprlock"

      # Move focus
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # Special workspace (scratchpad)
      "$mod, S, togglespecialworkspace, magic"
      "$mod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Application shortcuts
      "$mod, return, exec, $terminal"
      "$mod, B, exec, $browser"
      "$mod, V, exec, code"
      "$mod, A, exec, $dmenu"
      "$mod, R, exec, ls /run/current-system/sw/bin/ | $dmenu -d | bash"
      "$mod, period, exec, bemoji -cn"
    ] ++ (
      # Workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9)
    );
    bindm = [
      # Move/resize windows
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    bindel = [
      # Audio
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      
      # OSD
      ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
      ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];
    bindl = [
      # Media
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}