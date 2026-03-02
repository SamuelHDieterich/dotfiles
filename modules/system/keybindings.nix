# This is a module to define default application and their keybindings. Each configuration can override these defaults, and each desktop environment or window manager can use these values to set up their keybindings.

{
  lib,
  ...
}:
with lib;
with types;
let
  # Custom type for keybindings to ensure consistency and provide better documentation.
  keybindingType = submodule {
    options = {
      packages = mkOption {
        type = listOf package;
        description = "A list of packages associated with this keybinding. This is used for automatic installation of required applications.";
      };
      command = mkOption {
        type = str;
        description = "The command to execute when the keybinding is triggered";
      };
      keybinding = mkOption {
        type = oneOf [
          str
          (listOf str)
        ];
        description = "The key combination that triggers this command. Use config.keybindings.mod as the modifier key (e.g., SUPER, ALT) and separate keys with commas.";
      };
      description = mkOption {
        type = nullOr str;
        description = "A human-readable description of what this keybinding does.";
        default = null;
      };
    };
  };

  # Define the keybindings options with defaults for various applications and actions.
  keybindings =
    { config, pkgs }:
    let
      cfg = config.keybindings;
      rofi-command = "${lib.getExe config.programs.rofi.finalPackage} -steal-focus";
    in
    {
      mod = mkOption {
        type = enum [
          "SUPER"
          "ALT"
        ];
        default = "SUPER";
        description = "The modifier key to use in keybindings (e.g., SUPER, ALT).";
      };
      applications = mkOption {
        type = submodule {
          options = {
            terminal = mkOption {
              type = keybindingType;
              default = {
                packages = with pkgs; [ foot ];
                command = lib.getExe' pkgs.foot "footclient";
                keybinding = "${cfg.mod}, return";
                description = "Terminal emulator";
              };
            };
            filemanager = mkOption {
              type = submodule {
                options = {
                  graphical = mkOption {
                    type = keybindingType;
                    default = {
                      packages = with pkgs; [ thunar ];
                      command = lib.getExe pkgs.thunar;
                      keybinding = "${cfg.mod}, E";
                      description = "Graphical file manager";
                    };
                  };
                  terminal = mkOption {
                    type = keybindingType;
                    default = {
                      packages = with pkgs; [ yazi ];
                      command = cfg.terminal.command + lib.getExe pkgs.yazi;
                      keybinding = "${cfg.mod} SHIFT, E";
                      description = "Terminal-based file manager";
                    };
                  };
                };
              };
              default = { };
            };
            webbrowser = mkOption {
              type = keybindingType;
              default = {
                packages = with pkgs; [ firefox ];
                command = lib.getExe pkgs.firefox;
                keybinding = "${cfg.mod}, B";
                description = "Web browser";
              };
            };
            editor = mkOption {
              type = submodule {
                options = {
                  terminal = mkOption {
                    type = keybindingType;
                    default = {
                      packages = with pkgs; [ neovim ];
                      command = cfg.terminal.command + lib.getExe' pkgs.neovim "nvim";
                      keybinding = "${cfg.mod} SHIFT, V";
                      description = "Terminal-based text editor";
                    };
                  };
                  graphical = mkOption {
                    type = keybindingType;
                    default = {
                      packages = with pkgs; [ vscode ];
                      command = lib.getExe' pkgs.vscode "code";
                      keybinding = "${cfg.mod}, V";
                      description = "Graphical text editor";
                    };
                  };
                };
              };
              default = { };
            };
            pass = mkOption {
              type = keybindingType;
              default = {
                packages = with pkgs; [ keepassxc ];
                command = lib.getExe pkgs.keepassxc;
                keybinding = "${cfg.mod}, K";
                description = "Password manager";
              };
            };
            lock = mkOption {
              type = keybindingType;
              default = {
                packages = with pkgs; [ hyprlock ];
                command = "${lib.getExe pkgs.hyprlock} --grace 5";
                keybinding = "${cfg.mod}, L";
                description = "Lock the screen";
              };
            };
            launcher = mkOption {
              type = submodule {
                options = {
                  drun = mkOption {
                    type = keybindingType;
                    default = {
                      packages = with pkgs; [ rofi ];
                      command = "${rofi-command} -show drun -show-icons";
                      keybinding = "${cfg.mod}, A";
                      description = "Application launcher";
                    };
                  };
                  run = mkOption {
                    type = keybindingType;
                    default = {
                      packages = with pkgs; [ rofi ];
                      command = "${rofi-command} -show run -no-show-icons";
                      keybinding = "${cfg.mod}, R";
                      description = "Run command";
                    };
                  };
                };
              };
              default = { };
            };
            emoji = mkOption {
              type = keybindingType;
              default = {
                packages = with pkgs; [ rofi ];
                command = "${rofi-command} -show emoji -no-show-icons -emoji-mode copy";
                keybinding = "${cfg.mod}, period";
                description = "Emoji picker";
              };
            };
            colorpicker = mkOption {
              type = keybindingType;
              default = {
                packages = with pkgs; [ hyprpicker ];
                command = "${lib.getExe pkgs.hyprpicker} -a";
                keybinding = "${cfg.mod}, P";
                description = "Color picker";
              };
            };
            screenshots =
              let
                screenshot = {
                  packages = with pkgs; [
                    hyprshot
                    swappy
                  ];
                  command = pkgs.writeShellScript "screenshot-command" ''
                    SCREENSHOT_DIR=~/Pictures/Screenshots
                    FILENAME=$(date +%Y-%m-%d_%H-%M-%S)
                    mkdir -p $SCREENSHOT_DIR
                    ${lib.getExe pkgs.hyprshot} -m $1 -z -s -o $SCREENSHOT_DIR -f $FILENAME.png
                    sleep 0.5 # Wait for the screenshot to be saved
                    ${lib.getExe pkgs.swappy} -f $SCREENSHOT_DIR/$FILENAME.png
                  '';
                };
              in
              mkOption {
                type = submodule {
                  options = {
                    region = mkOption {
                      type = keybindingType;
                      default = {
                        packages = screenshot.packages;
                        command = "${screenshot.command} region";
                        keybinding = [
                          ", Print"
                          "${cfg.mod}, S"
                        ];
                        description = "Take a screenshot of a selected region";
                      };
                    };
                    window = mkOption {
                      type = keybindingType;
                      default = {
                        packages = screenshot.packages;
                        command = "${screenshot.command} window";
                        keybinding = [
                          "SHIFT, Print"
                          "${cfg.mod} SHIFT, S"
                        ];
                        description = "Take a screenshot of the active window";
                      };
                    };
                    monitor = mkOption {
                      type = keybindingType;
                      default = {
                        packages = screenshot.packages;
                        command = "${screenshot.command} monitor";
                        keybinding = [
                          "ALT, Print"
                          "${cfg.mod} ALT, S"
                        ];
                        description = "Take a screenshot of the entire screen";
                      };
                    };
                  };
                };
                default = { };
              };
          };
        };
        default = { };
      };
    };

  # Helper function to extract all packages from the keybindings configuration for automatic installation.
  getPackages =
    keybinding:
    let
      extractPackages =
        value:
        if isAttrs value then
          if value ? packages then
            value.packages
          else
            builtins.concatLists (map extractPackages (builtins.attrValues value))
        else
          [ ];
    in
    extractPackages keybinding;
in
{
  # NixOS module
  flake.nixosModules.keybindings =
    { config, pkgs, ... }:
    {
      options.keybindings = keybindings { inherit config pkgs; };

      # Install all packages used in keybindings
      config.environment.systemPackages = getPackages config.keybindings.applications;
    };

  # home-manager module
  flake.homeModules.keybindings =
    { config, pkgs, ... }:
    {
      options.keybindings = keybindings { inherit config pkgs; };

      # Install all packages used in keybindings
      config.home.packages = getPackages config.keybindings.applications;
    };
}
