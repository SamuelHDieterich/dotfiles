{ pkgs, ... }:
let bookmarks = pkgs.callPackage ./bookmarks.nix { };
in {
  home.packages = with pkgs; [ ouch hexyl duckdb ];
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = with pkgs.yaziPlugins; {
      inherit
        git; # Show the status of Git file changes as linemode in the file list
      inherit ouch; # Preview archives
      inherit sudo; # Call sudo in Yazi
      inherit piper; # Pipe any shell command as a previewer
      inherit chmod; # Execute chmod on the selected files to change their mode
      inherit mount; # Mount manager
      inherit rsync; # Simple rsync plugin
      inherit duckdb; # Uses duckdb to preview data files
      inherit starship; # Starship prompt integration
      inherit smart-enter; # Open files or enter directories all in one key
      inherit bookmarks; # Vi-like marks for files and directories
      inherit
        toggle-pane; # Toggle the show, hide, and maximize states for different panes
    };
    initLua = ./init.lua;
    settings = {
      plugin = {
        prepend_fetchers = [
          # Git
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
        prepend_previewers = [
          # Ouch
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }
          # DuckDB
          {
            url = "*.{csv,tsv,parquet,json,ndjson,jsonl,xlsx,xls,db,duckdb}";
            run = "duckdb";
          }
        ];
        append_previewers = [
          # Hexyl
          {
            url = "*";
            run = "piper -- hexyl --border=none --terminal-width=$w $1";
          }
        ];
        prepend_preloaders = [
          # DuckDB
          {
            url = "*.{csv,tsv,parquet,json,ndjson,jsonl,xlsx,xls,db,duckdb}";
            run = "duckdb";
            multi = false;
          }
        ];
      };
    };
    keymap = {
      mgr = {
        prepend_keymap = [
          {
            # Smart enter
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory or open the file";
          }
          # Toggle pane
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
          # Mount
          ## m - Mount the partition
          ## u - Unmount the partition
          ## e = Eject the disk
          {
            on = "M";
            run = "plugin mount";
            desc = "Open the mount manager";
          }
          # Bookmarks
          {
            on = [ "m" ];
            run = "plugin bookmarks save";
            desc = "Save current position as a bookmark";
          }
          {
            on = [ "g" "m" ];
            run = "plugin bookmarks jump";
            desc = "Jump to a bookmark";
          }
          {
            on = [ "b" "d" ];
            run = "plugin bookmarks delete";
            desc = "Delete a bookmark";
          }
          {
            on = [ "b" "D" ];
            run = "plugin bookmarks delete_all";
            desc = "Delete all bookmarks";
          }
          # DuckDB
          {
            on = "H";
            run = "plugin duckdb -1";
            desc = "Scroll one column to the left";
          }
          {
            on = "L";
            run = "plugin duckdb +1";
            desc = "Scroll one column to the right";
          }
          {
            on = [ "g" "o" ];
            run = "plugin duckdb -open";
            desc = "open with duckdb";
          }
          {
            on = [ "g" "u" ];
            run = "plugin duckdb -ui";
            desc = "open with duckdb ui";
          }
        ];
      };
    };
  };
}
