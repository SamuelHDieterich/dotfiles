{ pkgs, ... }: {
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override { cudaSupport = true; };
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs # Use smartphone as a source camera
      obs-backgroundremoval # Remove background without a green screen
    ];
  };
}
