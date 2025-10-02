{ pkgs, libs, ... }: {
  vim = {
    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
    };

    statusline.lualine.enable = true;
    telescope.enable = true;
    filetree.nvimTree.enable = true;
    lsp.enable = true;
    autocomplete.nvim-cmp.enable = true;

    languages = {
      enableTreesitter = true;

      nix.enable = true;
      rust.enable = true;
      python.enable = true;
      sql.enable = true;
    };
  };
}
