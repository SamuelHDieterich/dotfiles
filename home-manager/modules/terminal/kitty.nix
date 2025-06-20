{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 10;
    };
    settings = {
      confirm_os_window_close = 0;
      background_opacity = "0.9";
      enable_audio_bell = false;
      window_margin_width = 10;
      hide_window_decorations = true;
    };
  };
}
