# Git: change markers and blame, a status/staging screen, VS Code-style diffs and history, and GitHub pull requests.
{
  flake.nixvimModules.neovim = {
    # gitsigns: marks changed lines in the gutter; stage, reset or preview one hunk at a time; blame
    plugins.gitsigns = {
      enable = true;
      settings.current_line_blame = true; # Author and date of the current line, shown at its end
    };

    # neogit: Magit-style status screen to stage files, hunks or lines, commit, push and pull; press ? inside it for every key
    plugins.neogit.enable = true;

    # codediff: VS Code's own diff engine; side-by-side editable diffs, a changed-files explorer, and commit history per file or repo
    plugins.codediff = {
      enable = true;
      settings.diff.cycle_hunks_across_files = true; # ]c/[c walk into the next/previous file instead of stopping at its edges
    };

    # octo: browse, review and comment on GitHub pull requests and issues, using the gh CLI's login
    plugins.octo = {
      enable = true;
      settings.picker = "fzf-lua";
    };

    keymaps = [
      # Status and diffs
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<CR>";
        options.desc = "Status (stage, commit, push)";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>CodeDiff<CR>";
        options.desc = "Diff changes vs HEAD";
      }

      # History
      {
        mode = "n";
        key = "<leader>gh";
        action = "<cmd>CodeDiff history HEAD~50 %<CR>";
        options.desc = "File history";
      }
      {
        mode = "v";
        key = "<leader>gh";
        action = ":CodeDiff history<CR>";
        options.desc = "History of selected lines";
      }
      {
        mode = "n";
        key = "<leader>gH";
        action = "<cmd>CodeDiff history<CR>";
        options.desc = "Repository history";
      }

      # Hunks and blame
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>Gitsigns stage_hunk<CR>";
        options.desc = "Stage hunk";
      }
      {
        mode = "n";
        key = "<leader>gr";
        action = "<cmd>Gitsigns reset_hunk<CR>";
        options.desc = "Reset hunk";
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>Gitsigns preview_hunk_inline<CR>";
        options.desc = "Preview hunk";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<CR>";
        options.desc = "Blame line";
      }
      {
        mode = "n";
        key = "<leader>gB";
        action = "<cmd>Gitsigns blame<CR>";
        options.desc = "Blame file";
      }
      {
        mode = "n";
        key = "<leader>ub";
        action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
        options.desc = "Toggle line blame";
      }
      {
        mode = "n";
        key = "]h";
        action = "<cmd>Gitsigns nav_hunk next<CR>";
        options.desc = "Next git hunk";
      }
      {
        mode = "n";
        key = "[h";
        action = "<cmd>Gitsigns nav_hunk prev<CR>";
        options.desc = "Previous git hunk";
      }

      # GitHub
      {
        mode = "n";
        key = "<leader>op";
        action = "<cmd>Octo pr list<CR>";
        options.desc = "Pull requests";
      }
      {
        mode = "n";
        key = "<leader>oi";
        action = "<cmd>Octo issue list<CR>";
        options.desc = "Issues";
      }
      {
        mode = "n";
        key = "<leader>or";
        action = "<cmd>Octo review start<CR>";
        options.desc = "Start PR review";
      }
    ];
  };
}
