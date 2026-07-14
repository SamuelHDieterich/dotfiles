{
  # TEMPORARY: waybar's mango module was added upstream on 2026-05-29 but has
  # not shipped in a tagged release yet (latest is 0.15.0, from before that).
  # Build from a post-mango master commit until a release (likely 0.16.0)
  # includes it, then delete this file and its imports in hosts/*.
  # https://github.com/Alexays/Waybar/commit/3eeffbe3
  flake.nixosModules.waybarMangoOverlay = {
    nixpkgs.overlays = [
      (final: prev: {
        waybar =
          (prev.waybar.override {
            # master bumped the vendored cava subproject (0.10.7-beta ->
            # 0.10.7), which breaks 0.15.0's package.nix postUnpack step that
            # stages it under the old versioned directory name. Disabling
            # cava sidesteps that unrelated drift.
            cavaSupport = false;
          }).overrideAttrs
            (old: {
              src = prev.fetchFromGitHub {
                owner = "Alexays";
                repo = "Waybar";
                rev = "cf19c836d3dafc1646bb60a49269d981623b680a";
                hash = "sha256-h1ZmLmqBkm3MyShV6p83kBtpeLa9rnZUVz75kp+0Ccw=";
              };
              # master added a WWAN (ModemManager) module not present in
              # 0.15.0's package inputs; disable it rather than wiring up
              # mm-glib for this temporary override.
              mesonFlags = old.mesonFlags ++ [ "-Dwwan=disabled" ];
            });
      })
    ];
  };
}
