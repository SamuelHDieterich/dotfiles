# AI: Claude Code connected to the editor, the way its VS Code extension is.
{
  flake.nixvimModules.neovim = {
    # claudecode: runs Claude Code in a right-hand split and tells it which file and lines you have selected; its proposed edits open as a diff you can edit, then accept or reject
    plugins.claudecode = {
      enable = true;
      settings = {
        terminal.split_width_percentage = 0.35;
        log_level = "warn"; # Only show warnings and errors, not routine connection messages
      };
    };

    # Use the `claude` already on PATH
    dependencies.claude-code.enable = false;

    keymaps = [
      {
        mode = "n";
        key = "<leader>ac";
        action = "<cmd>ClaudeCode<CR>";
        options.desc = "Toggle Claude";
      }
      {
        mode = "n";
        key = "<leader>af";
        action = "<cmd>ClaudeCodeFocus<CR>";
        options.desc = "Focus Claude";
      }
      {
        mode = "n";
        key = "<leader>ar";
        action = "<cmd>ClaudeCode --resume<CR>";
        options.desc = "Resume a Claude session";
      }
      {
        mode = "n";
        key = "<leader>am";
        action = "<cmd>ClaudeCodeSelectModel<CR>";
        options.desc = "Select Claude model";
      }
      {
        mode = "n";
        key = "<leader>ab";
        action = "<cmd>ClaudeCodeAdd %<CR>";
        options.desc = "Add current file to Claude";
      }
      {
        mode = "v";
        key = "<leader>as";
        action = "<cmd>ClaudeCodeSend<CR>";
        options.desc = "Send selection to Claude";
      }
      {
        mode = "n";
        key = "<leader>aa";
        action = "<cmd>ClaudeCodeDiffAccept<CR>";
        options.desc = "Accept Claude's diff";
      }
      {
        mode = "n";
        key = "<leader>ad";
        action = "<cmd>ClaudeCodeDiffDeny<CR>";
        options.desc = "Reject Claude's diff";
      }
    ];
  };
}
