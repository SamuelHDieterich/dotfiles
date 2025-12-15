{ pkgs, ... }: {
  home.packages = with pkgs; [ dunst libnotify ];
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        font = "JetBrainsMono Nerd Font Mono 8";
        corner_radius = 5;
      };
      urgency_low = {
        timeout = 5;
        background = "#151515";
        foreground = "#888888";
      };
      urgency_normal = {
        timeout = 15;
        background = "#1e1e2e";
        foreground = "#ffffff";
      };
      urgency_critical = {
        timeout = 0;
        background = "#f38ba8";
        foreground = "#000000";
      };
    };
  };
}
