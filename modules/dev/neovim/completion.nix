# Autocompletion: suggestions from language servers, file paths, snippets and words already in open files.
{
  flake.nixvimModules.neovim = {
    # blink.cmp: completion menu. Ctrl+n/Ctrl+p move, Ctrl+y accepts, Ctrl+e closes, Ctrl+Space opens it manually
    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "default";
        completion.documentation.auto_show = true; # Show docs next to the highlighted item
        signature.enabled = true; # Show the function signature while typing arguments
        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
      };
    };

    # friendly-snippets: ready-made snippets for most languages, offered by blink.cmp
    plugins.friendly-snippets.enable = true;
  };
}
