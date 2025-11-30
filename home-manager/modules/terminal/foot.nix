{ pkgs, ... }: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/kitty";
        font = "JetBrainsMono Nerd Font Mono:size=10";
        horizontal-letter-offset = 1;
      };
    };
  };
}
