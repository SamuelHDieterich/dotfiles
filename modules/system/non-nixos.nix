/*
  This module provides the configuration for non-NixOS systems, such as Home Manager on Linux or macOS (not tested).
  It includes settings that are necessary for Home Manager to function properly on these platforms.
*/

{ inputs, ... }:
{
  flake.homeModules.nonNixos =
    { pkgs, ... }:
    {
      nix.package = pkgs.nix; # Set nix package
      programs.bash.enable = true; # Bash is required
      targets.genericLinux = {
        enable = true; # Required for non-NixOS systems
        # NixGL for OpenGL support on non-NixOS systems
        nixGL = {
          packages = inputs.nixgl.packages;
          defaultWrapper = "mesa";
          installScripts = [ "mesa" ];
          vulkan.enable = true;
        };
      };
      fonts.fontconfig.enable = true; # Enable fontconfig for font management
    };
}
