{
  flake-file.inputs = {
    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TEMPORARY
    # nixpkgs dropped Firefox ESR 140 on 2026-09-28 and moved zotero to ESR 153, which Zotero 10 doesn't support, so zotero fails to build.
    # Last nixos-unstable rev before that drop. Delete this input and its use in metapackages.nix once zotero builds on nixpkgs again.
    # https://github.com/NixOS/nixpkgs/issues/568692
    nixpkgs-zotero.url = "github:NixOS/nixpkgs/20b1ddd1aa5ace70c9468305030aa4f9ef79671b";
    # OpenGL for non-NixOS systems
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
