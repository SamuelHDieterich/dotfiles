{ config, pkgs, lib, ... }: {
  imports = [ ../../utilities/rofi.nix ];
  xdg.configFile = {
    "swappy/config".text = ''
      [Default]
      save_dir=~/Pictures/Screenshots
      save_filename_format=%Y-%m-%d_%H-%M-%S.png
    '';
  };

  wayland.windowManager.hyprland.settings = let
    rofi-command =
      "${lib.getExe config.programs.rofi.finalPackage} -steal-focus";
    screenshot-command = mode:
      pkgs.writeShellScript "screenshot-command" ''
        SCREENSHOT_DIR=~/Pictures/Screenshots
        FILENAME=$(date +%Y-%m-%d_%H-%M-%S)
        mkdir -p $SCREENSHOT_DIR
        ${
          lib.getExe pkgs.hyprshot
        } -m ${mode} -z -s -o $SCREENSHOT_DIR -f $FILENAME.png
        sleep 0.5 # Wait for the screenshot to be saved
        ${lib.getExe pkgs.swappy} -f $SCREENSHOT_DIR/$FILENAME.png
      '';
  in {
    "$mod" = "SUPER";
    "$terminal" = lib.getExe pkgs.kitty;
    "$filemanager" = lib.getExe pkgs.xfce.thunar;
    "$webbrowser" = lib.getExe pkgs.firefox;
    "$editor" = lib.getExe pkgs.vscode;
    "$pass" = lib.getExe pkgs.keepassxc;
    "$lock" = lib.getExe pkgs.hyprlock;
    "$drun" = "${rofi-command} -show drun -show-icons";
    "$run" = "${rofi-command} -show run -no-show-icons";
    "$emoji" = "${rofi-command} -show emoji -no-show-icons -emoji-mode copy";
    "$colorpicker" = "${lib.getExe pkgs.hyprpicker} -a";
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
      "$mod, Z, togglespecialworkspace, magic"
      "$mod SHIFT, Z, movetoworkspace, special:magic"

      # Scroll through existing workspaces
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # Application shortcuts
      "$mod, return, exec, $terminal"
      "$mod, E, exec, $filemanager"
      "$mod, B, exec, $webbrowser"
      "$mod, V, exec, $editor"
      "$mod, K, exec, $pass"
      "$mod, A, exec, $drun"
      "$mod, R, exec, $run"
      "$mod, period, exec, $emoji"
      "$mod, P, exec, $colorpicker"

      # Screenshots
      ", Print, exec, ${screenshot-command "region"}"
      "$mod, S, exec, ${screenshot-command "region"}"
      "SHIFT, Print, exec, ${screenshot-command "window"}"
      "$mod SHIFT, S, exec, ${screenshot-command "window"}"
      "ALT, Print, exec, ${screenshot-command "output"}"
      "$mod ALT, S, exec, ${screenshot-command "output"}"
    ] ++ (
      # Workspaces
      # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
      builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]) 9));
    bindm = [
      # Move/resize windows
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    bindel = [
      # Audio
      ", XF86AudioRaiseVolume, exec, ${
        lib.getExe' pkgs.wireplumber "wpctl"
      } set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, ${
        lib.getExe' pkgs.wireplumber "wpctl"
      } set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute, exec, ${
        lib.getExe' pkgs.wireplumber "wpctl"
      } set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, ${
        lib.getExe' pkgs.wireplumber "wpctl"
      } set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      # OSD
      ", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} s 10%+"
      ", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} s 10%-"
    ];
    bindl = [
      # Media
      ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
      ", XF86AudioPause, exec, ${lib.getExe pkgs.playerctl} play-pause"
      ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
      ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
    ];
  };
}
