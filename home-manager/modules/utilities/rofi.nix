{ config, pkgs, lib, ... }: {
  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-calc rofi-emoji ];

    font = "JetBrainsMono Nerd Font Mono 12";
    terminal = lib.getExe config.programs.kitty.package;
    extraConfig = { modes = "drun,run,calc,emoji"; };
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {

      configuration = {
        drun-display-format = "{name}";
        display-drun = "";
        display-run = "";
        display-emoji = "☺";
        display-calc = "";
      };

      # Based on Newman Sanchez (https://github.com/newmanls) rounded theme

      "*" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";

        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        spacing = mkLiteral "0px";

        bg0 = mkLiteral "#212121F2";
        bg1 = mkLiteral "#2A2A2A";
        bg2 = mkLiteral "#3D3D3D80";
        bg3 = mkLiteral "#AB47BCF2";
        fg0 = mkLiteral "#E6E6E6";
        fg1 = mkLiteral "#FFFFFF";
        fg2 = mkLiteral "#969696";
        fg3 = mkLiteral "#3D3D3D";
      };

      window = {
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        width = 480;
        border-radius = mkLiteral "24px";
        background-color = mkLiteral "@bg0";
        transparency = "real";
      };

      mainbox = { padding = mkLiteral "12px"; };

      inputbar = {
        background-color = mkLiteral "@bg1";
        border-color = mkLiteral "@bg3";

        border = mkLiteral "2px";
        border-radius = mkLiteral "16px";

        padding = mkLiteral "8px 16px";
        spacing = mkLiteral "8px";
        children = map mkLiteral [ "prompt" "entry" ];
      };

      prompt = { text-color = mkLiteral "@fg2"; };

      entry = {
        placeholder = "Search";
        placeholder-color = mkLiteral "@fg3";
      };

      message = {
        margin = mkLiteral "12px 0 0";
        border-radius = mkLiteral "16px";
        border-color = mkLiteral "@bg2";
        background-color = mkLiteral "@bg2";
      };

      textbox = { padding = mkLiteral "8px 24px"; };

      listview = {
        background-color = mkLiteral "transparent";

        margin = mkLiteral "12px 0 0";
        lines = 8;
        columns = 1;

        fixed-height = true;
      };

      element = {
        padding = mkLiteral "8px 16px";
        spacing = mkLiteral "8px";
        border-radius = mkLiteral "16px";
      };

      "element normal active" = { text-color = mkLiteral "@bg3"; };

      "element alternate active" = { text-color = mkLiteral "@bg3"; };

      "element selected normal, element selected active" = {
        background-color = mkLiteral "@bg3";
      };

      element-icon = {
        size = mkLiteral "1em";
        vertical-align = mkLiteral "0.5";
      };

      element-text = { text-color = mkLiteral "inherit"; };
    };
  };
}
