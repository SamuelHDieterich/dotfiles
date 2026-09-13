# Look and layout: colours, icons, statusline, buffer tabs and a sticky header for the current scope.
{
  flake.nixvimModules.neovim = {
    # onedark, recoloured as Hyper Term Black: pure black background with the One Dark Pro "Vivid" accents
    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "darker";
        # The darkest layers are forced to pure black; the lighter layers stay very dark grey so floats and the cursor line remain visible
        colors = {
          black = "#000000";
          bg0 = "#000000";
          bg_d = "#000000";
          bg1 = "#141414";
          bg2 = "#1e1e1e";
          bg3 = "#282828";
          fg = "#AAB1C0";
          grey = "#5C6370";
          red = "#EF596F";
          orange = "#D8985F";
          yellow = "#E5C07B";
          green = "#89CA78";
          cyan = "#2BBAC5";
          blue = "#52ADF2";
          purple = "#D55FDE";
        };
        highlights = {
          Visual.bg = "#484e5b"; # Selection
          LineNr.fg = "#495162";
        };
      };
    };

    # web-devicons: file-type icons for the explorer, tabs and statusline (needs a Nerd Font in the terminal)
    plugins.web-devicons.enable = true;

    # lualine: statusline showing mode, git branch, diagnostics and file type
    plugins.lualine.enable = true;

    # bufferline: open files shown as tabs along the top
    plugins.bufferline.enable = true;

    # treesitter-context: keeps the current function or class header pinned at the top while scrolling
    plugins.treesitter-context.enable = true;

    # fidget: small corner messages while language servers load or index
    plugins.fidget.enable = true;

    # dashboard-nvim: start screen shown when Neovim opens with no file, with recent files and quick actions
    plugins.dashboard = {
      enable = true;
      settings = {
        theme = "hyper"; # dashboard-nvim's richer layout: header, shortcuts, recent files, footer
        config = {
          mru.limit = 10; # Recent files list
          header = [
            ""
            "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
            "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ""
          ];
          shortcut = [
            {
              desc = " Files";
              key = "f";
              action = "FzfLua files";
            }
            {
              desc = " Recent";
              key = "r";
              action = "FzfLua oldfiles";
            }
            {
              desc = " Explorer";
              key = "e";
              action = "Neotree";
            }
          ];
        };
      };
    };
  };
}
