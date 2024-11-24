{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    git = {
      enable = true;
      userName = "Samuel Huff Dieterich";
      userEmail = "72668845+SamuelHDieterich@users.noreply.github.com";
    };
    lazygit.enable = true;
    gh.enable = true;
  };
}
