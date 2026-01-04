{ pkgs, ... }: {
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
      inherit rsync; # Simple rsync plugin
      inherit duckdb; # Uses duckdb to preview data files
      inherit starship; # Starship prompt integration
      inherit smart-enter; # Open files or enter directories all in one key
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
            # run = lib.getExe pkgs.ouch;
            run = "ouch";
          }
        ];
      };
    };
    keymap = {
      mgr = {
        prepend_keymap = [{
          # Smart enter
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter the child directory or open the file";
        }];
      };
    };
  };
}
