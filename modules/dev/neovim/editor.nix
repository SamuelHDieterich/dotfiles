# Core editing behaviour: options, leader key, clipboard, filetype fixes and key discovery.
{
  flake.nixvimModules.neovim = {
    # `vi` and `vim` also open this Neovim
    viAlias = true;
    vimAlias = true;

    # Leader keys
    globals = {
      mapleader = " "; # Space starts every custom shortcut
      maplocalleader = "\\";
      tex_flavor = "latex"; # Treat .tex files as LaTeX, not plain TeX
    };

    # Editor options
    opts = {
      number = true;
      relativenumber = true; # Numbers count from the cursor, so jumps like 5j are easy to read
      signcolumn = "yes"; # Always keep the sign gutter so git/diagnostic marks don't shift the text
      cursorline = true;
      wrap = true; # Soft-wrap long lines
      linebreak = true; # Wrap at word boundaries
      breakindent = true; # Wrapped lines keep their indentation
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      ignorecase = true;
      smartcase = true; # Search becomes case-sensitive only when the pattern has capitals
      splitright = true;
      splitbelow = true;
      scrolloff = 8;
      undofile = true; # Undo history survives closing the file
      updatetime = 250; # Faster hover/blame refresh
      confirm = true; # Ask to save instead of refusing to quit
      foldlevelstart = 99; # Open files with every fold expanded
    };

    # Yank and paste through the Wayland system clipboard
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # Filetypes Neovim detects wrongly or not at all
    filetype = {
      extension = {
        tf = "terraform"; # Otherwise detected as TinyFugue and terraform-ls never starts
        conf = "conf";
      };
      filename = {
        "poetry.lock" = "toml";
      };
    };

    # which-key: after pressing a prefix like <Space>, g or z, shows every key that can follow and what it does
    plugins.which-key = {
      enable = true;
      settings = {
        preset = "modern";
        spec = [
          {
            __unkeyed-1 = "<leader>a";
            group = "AI";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "Buffers";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "Find";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "Git";
          }
          {
            __unkeyed-1 = "<leader>o";
            group = "GitHub";
          }
          {
            __unkeyed-1 = "<leader>p";
            group = "Preview";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "Search and replace";
          }
          {
            __unkeyed-1 = "<leader>u";
            group = "Toggles";
          }
          {
            __unkeyed-1 = "<leader>x";
            group = "Problems";
          }
        ];
      };
    };

    # tmux-navigator: Ctrl+h/j/k/l moves between Neovim splits and tmux panes as if they were one grid
    plugins.tmux-navigator.enable = true;

    # mini.pairs: types the closing bracket or quote for you
    plugins.mini-pairs.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlight";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<CR>";
        options.desc = "Delete buffer";
      }
      {
        mode = "n";
        key = "<leader>uw";
        action = "<cmd>set wrap!<CR>";
        options.desc = "Toggle line wrap";
      }
    ];
  };
}
