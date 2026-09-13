# Writing: live Typst preview and rendered Markdown.
{
  flake.nixvimModules.neovim = {
    # typst-preview: live preview of the Typst document in the browser, following the cursor as you type
    plugins.typst-preview.enable = true;

    # render-markdown: draws headings, tables, code blocks and checkboxes inside Markdown buffers; the cursor line shows the raw text
    plugins.render-markdown.enable = true;

    # markdown-preview: live, scroll-synced Markdown preview in the browser, with full Mermaid rendering
    plugins.markdown-preview = {
      enable = true;
      settings.theme = "dark";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>pt";
        action = "<cmd>TypstPreviewToggle<CR>";
        options.desc = "Typst preview";
      }
      {
        mode = "n";
        key = "<leader>pm";
        action = "<cmd>RenderMarkdown toggle<CR>";
        options.desc = "Toggle Markdown rendering";
      }
      {
        mode = "n";
        key = "<leader>pv";
        action = "<cmd>MarkdownPreviewToggle<CR>";
        options.desc = "Markdown preview (browser)";
      }
    ];
  };
}
