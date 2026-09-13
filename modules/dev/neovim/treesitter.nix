# Syntax awareness from tree-sitter: accurate highlighting, indentation and code folding.
{
  flake.nixvimModules.neovim = {
    # nvim-treesitter: parses code into a syntax tree; every packaged grammar is installed through Nix, so all languages highlight out of the box
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true; # zc/zo/za fold by syntax; files still open unfolded
    };
  };
}
