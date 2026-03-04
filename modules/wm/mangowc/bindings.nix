{ inputs, ... }:
{
  flake.homeModules.mangowc =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ inputs.self.homeModules.rofi ];
      xdg.configFile = {
        "swappy/config".text = ''
          [Default]
          save_dir=~/Pictures/Screenshots
          save_filename_format=%Y-%m-%d_%H-%M-%S.png
        '';
      };

      wayland.windowManager.mango.settings =
        let
          mod = "SUPER";
          rofi-command = "${lib.getExe config.programs.rofi.finalPackage} -steal-focus";
          screenshot-command =
            mode:
            pkgs.writeShellScript "screenshot-command" ''
              SCREENSHOT_DIR=~/Pictures/Screenshots
              FILENAME=$(date +%Y-%m-%d_%H-%M-%S)
              mkdir -p $SCREENSHOT_DIR
              ${lib.getExe pkgs.hyprshot} -m ${mode} -z -s -o $SCREENSHOT_DIR -f $FILENAME.png
              sleep 0.5 # Wait for the screenshot to be saved
              ${lib.getExe pkgs.swappy} -f $SCREENSHOT_DIR/$FILENAME.png
            '';
          terminal = lib.getExe' pkgs.foot "footclient";
          filemanager = lib.getExe pkgs.thunar;
          webbrowser = lib.getExe pkgs.firefox;
          editor = lib.getExe pkgs.vscode;
          pass = lib.getExe pkgs.keepassxc;
          lock = "${lib.getExe pkgs.hyprlock} --grace 5";
          drun = "${rofi-command} -show drun -show-icons";
          run = "${rofi-command} -show run -no-show-icons";
          emoji = "${rofi-command} -show emoji -no-show-icons -emoji-mode copy";
          colorpicker = "${lib.getExe pkgs.hyprpicker} -a";
        in
        {
          # Key bindings
          bind = [
            # General system
            "${mod}, C,         killclient"
            "${mod}, Backspace, reload_config"
            "${mod}, Delete,    quit"
            "${mod}, F,         togglefullscreen"
            "${mod}, Space,     togglefloating"

            # # Monitor switching
            "${mod}+CTRL,   Left,   focusmon, left"
            "${mod}+CTRL,   Right,  focusmon, right"
            "${mod}+SHIFT,  Left,   tagmon,   left"
            "${mod}+SHIFT,  Right,  tagmon,   right"

            # Focus
            "${mod},      Left,   focusdir,   left"
            "${mod},      Right,  focusdir,   right"
            "${mod},      Up,     focusdir,   up"
            "${mod},      Down,   focusdir,   down"
            "${mod}+ALT,  Left,   focusstack, prev"
            "${mod}+ALT,  Down,   focusstack, prev"
            "${mod}+ALT,  Right,  focusstack, next"
            "${mod}+ALT,  Up,     focusstack, next"

            # Switch window status
            "${mod},  g,    toggleglobal,"
            "ALT,     Tab,  toggleoverview,"

            # Layout manipulation
            "${mod}, Tab, switch_layout"
            "${mod}, T,   setlayout, tile"
            "${mod}, M,   setlayout, monocle"

            # Applications shortcuts
            "${mod}, Return,  spawn, ${terminal}"
            "${mod}, E,       spawn, ${filemanager}"
            "${mod}, B,       spawn, ${webbrowser}"
            "${mod}, V,       spawn, ${editor}"
            "${mod}, K,       spawn, ${pass}"
            "${mod}, A,       spawn, ${drun}"
            "${mod}, R,       spawn, ${run}"
            "${mod}, Period,  spawn, ${emoji}"
            "${mod}, P,       spawn, ${colorpicker}"
            "${mod}, L,       spawn, ${lock}"

            # Screenshots
            "NONE,  Print,      spawn, ${screenshot-command "region"}"
            "${mod},        S,  spawn, ${screenshot-command "region"}"
            "SHIFT, Print,      spawn, ${screenshot-command "window"}"
            "${mod}+SHIFT,  S,  spawn, ${screenshot-command "window"}"
            "ALT,   Print,      spawn, ${screenshot-command "output"}"
            "${mod}+ALT,    S,  spawn, ${screenshot-command "output"}"

            # Brightness
            "NONE,  XF86MonBrightnessUp,    spawn, ${lib.getExe pkgs.brightnessctl} s +2%"
            "SHIFT, XF86MonBrightnessUp,    spawn, ${lib.getExe pkgs.brightnessctl} s 100%"
            "NONE,  XF86MonBrightnessDown,  spawn, ${lib.getExe pkgs.brightnessctl} s 2%-"
            "SHIFT, XF86MonBrightnessDown,  spawn, ${lib.getExe pkgs.brightnessctl} s 0%"

            # Volume
            "NONE,  XF86AudioRaiseVolume, spawn,  ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume  @DEFAULT_SINK@ 5%+"
            "NONE,  XF86AudioLowerVolume, spawn,  ${lib.getExe' pkgs.wireplumber "wpctl"} set-volume  @DEFAULT_SINK@ 5%-"
            "NONE,  XF86AudioMute,        spawn,  ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute    @DEFAULT_SINK@ toggle"
            "SHIFT, XF86AudioMute,        spawn,  ${lib.getExe' pkgs.wireplumber "wpctl"} set-mute    @DEFAULT_SOURCE@ toggle"

            # Media
            "NONE,  XF86AudioNext,    spawn,  ${lib.getExe pkgs.playerctl}  next"
            "NONE,  XF86AudioPause,   spawn,  ${lib.getExe pkgs.playerctl}  play-pause"
            "NONE,  XF86AudioPlay,    spawn,  ${lib.getExe pkgs.playerctl}  play-pause"
            "NONE,  XF86AudioPrev,    spawn,  ${lib.getExe pkgs.playerctl}  previous"
          ]
          ++ (
            # Tags
            # binds $mod + [shift +] {1..9} to [move to] tag {1..9}
            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "${mod},        ${toString ws}, view,       ${toString ws}, 0" # View tag
                  "${mod}+SHIFT,  ${toString ws}, tag,        ${toString ws}, 0" # Move to tag
                  "${mod}+ALT,    ${toString ws}, tagsilent,  ${toString ws}" # Move to tag without switching
                ]
              ) 9
            )
          );
          # Mouse bindings
          mousebind = [
            # Window manipulation
            "${mod},      btn_left,   moveresize, curmove"
            "${mod},      btn_right,  moveresize, curresize"
            "${mod}+CTRL, btn_right,  killclient"
          ];
          # Axis bindings
          axisbind = [
            "${mod},  UP,   viewtoleft_have_client"
            "${mod},  DOWN, viewtoright_have_client"
          ];
          # Gesture bindings
          gesturebind = [
            # 3-finger: Window focus
            "NONE,  left,   3,  focusdir, left"
            "NONE,  right,  3,  focusdir, right"
            "NONE,  up,     3,  focusdir, up"
            "NONE,  down,   3,  focusdir, down"

            # 4-finger: Workspace navigation
            "NONE,  left,   4,  viewtoleft_have_client"
            "NONE,  right,  4,  viewtoright_have_client"
            "NONE,  up,     4,  toggleoverview"
            "NONE,  down,   4,  toggleoverview"
          ];
          switchbind = [
            "fold,   spawn_shell, pidof hyprlock || hyprlock --grace 10"
            "unfold, spawn,       ${lib.getExe pkgs.wlopm} --on '*'"
          ];
        };
    };
}
