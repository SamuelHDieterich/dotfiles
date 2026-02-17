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
