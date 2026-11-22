{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      # Keyring
      services.gnome.gnome-keyring.enable = true;
      programs.seahorse.enable = true;

      # Disks
      services.gvfs.enable = true;
      services.udisks2.enable = true;

      # Thumbnails
      services.tumbler.enable = true;

      # Fonts
      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          nerd-fonts.jetbrains-mono
          caladea
          google-fonts
        ];
      };

      # Programs
      programs = {
        dconf.enable = true; # Enable dconf for desktop environment configuration
        command-not-found.enable = true; # Suggest the package providing a missing command
        nix-ld.enable = true; # Run unpatched dynamic binaries on NixOS. Needed for compilation (C, Rust).
      };
    };

  flake.homeModules.desktop =
    { pkgs, lib, ... }:
    {
      # Disks
      services.udiskie.enable = true;

      # Environment variables
      home.sessionVariables = {
        VISUAL = lib.getExe pkgs.vscode;
        MANPAGER = "env BATMAN_IS_BEING_MANPAGER=yes " + lib.getExe pkgs.bat-extras.batman;
      };
    };
}
