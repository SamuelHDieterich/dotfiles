# File explorer: a sidebar tree with icons and git status.
{
  flake.nixvimModules.neovim = {
    # neo-tree: sidebar file tree; its git_status view lists only changed files
    plugins.neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        log_to_file = false; # Without an explicit value, neo-tree tries to open a log file on every startup
        filesystem = {
          follow_current_file.enabled = true; # Highlight the open file in the tree
          use_libuv_file_watcher = true; # Refresh when files change on disk
          filtered_items.visible = true; # Show hidden and gitignored files, dimmed
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Explorer";
      }
      {
        mode = "n";
        key = "<leader>E";
        action = "<cmd>Neotree reveal<CR>";
        options.desc = "Reveal current file in explorer";
      }
      {
        mode = "n";
        key = "<leader>ge";
        action = "<cmd>Neotree float git_status<CR>";
        options.desc = "Changed files (tree)";
      }
    ];
  };
}
