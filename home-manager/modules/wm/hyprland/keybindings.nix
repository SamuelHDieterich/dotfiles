{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$terminal" = "${pkgs.kitty}/bin/kitty";
    "$filemanager" = "${pkgs.xfce.thunar}/bin/thunar";
    "$webbrowser" = "${pkgs.firefox}/bin/firefox";
    "$drun" = "${pkgs.rofi-wayland}/bin/rofi -show drun";
    "$run" = "${pkgs.rofi-wayland}/bin/rofi -show run";
    "$emoji" = "${pkgs.bemoji}/bin/bemoji -cn";
    "$lock" = "${pkgs.hyprlock}/bin/hyprlock";
    "$editor" = "${pkgs.vscode}/bin/code";
    bind = [
      # General system
      "$mod, C, killactive"
      "$mod, delete, exit"
      "$mod, F, fullscreen"
      "$mod, space, togglefloating"
      "$mod, L, exec, $lock"

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
      "$mod, E, exec, $filemanager"
      "$mod, B, exec, $webbrowser"
      "$mod, V, exec, $editor"
      "$mod, A, exec, $drun"
      "$mod, R, exec, $run"
      "$mod, period, exec, $emoji"
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
      ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      
      # OSD
      ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%+"
      ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
    ];
    bindl = [
      # Media
      ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
      ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
    ];
  };
}