# Finding things: fuzzy search over files, text, symbols and help, plus project-wide find and replace.
{
  flake.nixvimModules.neovim = {
    # fzf-lua: fuzzy finder with a live preview
    plugins.fzf-lua = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          action = "files";
          options.desc = "Files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Grep text";
        };
        "<leader>fw" = {
          action = "grep_cword";
          options.desc = "Grep word under cursor";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Open buffers";
        };
        "<leader>fr" = {
          action = "oldfiles";
          options.desc = "Recent files";
        };
        "<leader>fs" = {
          action = "lsp_document_symbols";
          options.desc = "Symbols in file";
        };
        "<leader>fS" = {
          action = "lsp_live_workspace_symbols";
          options.desc = "Symbols in project";
        };
        "<leader>fd" = {
          action = "diagnostics_workspace";
          options.desc = "Diagnostics";
        };
        "<leader>fh" = {
          action = "helptags";
          options.desc = "Help pages";
        };
        "<leader>fk" = {
          action = "keymaps";
          options.desc = "Keymaps";
        };
        "<leader>fc" = {
          action = "commands";
          options.desc = "Commands";
        };
        "<leader>f/" = {
          action = "blines";
          options.desc = "Lines in buffer";
        };
      };
    };

    # ripgrep and fd power the file and text search
    dependencies = {
      ripgrep.enable = true;
      fd.enable = true;
    };

    # grug-far: find and replace across the whole project, with a preview of every change
    plugins.grug-far.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>sr";
        action = "<cmd>GrugFar<CR>";
        options.desc = "Find and replace in project";
      }
    ];
  };
}
