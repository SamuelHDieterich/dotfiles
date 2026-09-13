# Formatting: every file is formatted on save by the formatter listed for its language.
{
  flake.nixvimModules.neovim =
    { lib, pkgs, ... }:
    {
      # conform: runs the listed formatter on save; languages without one fall back to their language server
      plugins.conform-nvim = {
        enable = true;
        # Install each listed formatter from nixpkgs
        autoInstall = {
          enable = true;
          overrides.terragrunt_hcl_format = null; # Custom formatter below, which already points at its binary
        };
        settings = {
          format_on_save = {
            timeout_ms = 1000;
            lsp_format = "fallback";
          };
          formatters_by_ft = {
            python = [
              "ruff_organize_imports"
              "ruff_format"
            ];
            nix = [ "nixfmt" ];
            terraform = [ "tofu_fmt" ];
            terraform-vars = [ "tofu_fmt" ];
            hcl = [ "terragrunt_hcl_format" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            toml = [ "taplo" ];
            c = [ "clang_format" ];
            json = [ "prettierd" ];
            jsonc = [ "prettierd" ];
            yaml = [ "prettierd" ];
            markdown = [ "prettierd" ];
            html = [ "prettierd" ];
            css = [ "prettierd" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            javascriptreact = [ "prettierd" ];
            typescriptreact = [ "prettierd" ];
          };
          # conform's built-in terragrunt formatter uses the old `hcl fmt` syntax and skips files named terragrunt.hcl
          formatters.terragrunt_hcl_format = {
            command = lib.getExe pkgs.terragrunt;
            args = [
              "hcl"
              "format"
              "--stdin"
            ];
            stdin = true;
          };
        };
      };

      keymaps = [
        # Lua one-liner: conform has no Ex command for formatting
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>cf";
          action.__raw = "function() require('conform').format({ lsp_format = 'fallback' }) end";
          options.desc = "Format";
        }
      ];
    };
}
