{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    kitty
    nerd-fonts.jetbrains-mono
  ];

  programs.kitty = lib.mkForce {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 10;
    };
    settings = {
      confirm_os_window_close = 0;
      background_opacity = "0.9";
    };
  };
}
