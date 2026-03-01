{
  flake.homeModules.git = {
    programs = {
      git = {
        enable = true;
        settings.user = {
          name = "Samuel Huff Dieterich";
          email = "72668845+SamuelHDieterich@users.noreply.github.com";
        };
      };
      lazygit.enable = true; # TUI for Git
      gh.enable = true; # GitHub CLI
    };
  };
}
