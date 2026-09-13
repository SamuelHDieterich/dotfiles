# Images and SVGs shown inline over the buffer text.
{
  flake.nixvimModules.neovim =
    { pkgs, lib, ... }:
    {
      # image.nvim queries the real terminal size on load, which errors out in the check's headless, non-TTY run;
      # enableExceptInTests keeps it enabled for actual use while excluding it from the startup check
      plugins.image = {
        enable = lib.nixvim.enableExceptInTests;
        settings = {
          backend = "ueberzug";
          hijack_file_patterns = [
            "*.png"
            "*.jpg"
            "*.jpeg"
            "*.gif"
            "*.webp"
            "*.avif"
            "*.svg" # Rasterised through ImageMagick's librsvg delegate
          ];
        };
      };

      extraPackages = with pkgs; [
        imagemagick # image.nvim's magick_cli processor needs this regardless of backend
      ];
    };
}
