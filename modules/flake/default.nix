{ inputs, ... }:
{
  imports = [ inputs.flake-file.flakeModules.dendritic ];

  flake-file.description = "Dotfiles configuration";

  # dendritic's default outputs only scans ./modules; keep our three import-tree roots.
  flake-file.outputs = ''
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree [
      ./hosts
      ./modules
      ./packages
    ])
  '';

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
