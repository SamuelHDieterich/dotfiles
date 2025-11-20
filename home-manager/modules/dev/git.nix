{ ... }: {
  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "Samuel Huff Dieterich";
        email = "72668845+SamuelHDieterich@users.noreply.github.com";
      };
    };
    lazygit.enable = true;
    gh.enable = true;
  };
}
