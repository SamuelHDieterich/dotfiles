{ pkgs, ... }: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
  environment.systemPackages = with pkgs; [ file-roller ];
}
