{ inputs, ... }:
{
  flake.modules.generic.xdg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      xdg.portal = {
        enable = true;
        config.common.default = [
          "wlr"
          "gtk"
        ];
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
      };
    };

  flake.nixosModules.xdg =
    { pkgs, ... }:
    let
      # xdg-desktop-portal-wlr's default screencast chooser tries a hardcoded list of menu binaries
      # (slurp, wmenu, wofi, rofi, bemenu, mew, fuzzel) by bare name over `sh -c`.
      # The systemd user unit it runs under has its own restricted PATH that doesn't include any of them,
      # so every candidate fails with "command not found" and the request errors out.

      # This script builds a combined screen/window list through rofi.
      xdpwChooser = pkgs.writeShellApplication {
        name = "xdpw-chooser";
        runtimeInputs = with pkgs; [
          wlr-randr
          lswt
          jq
          rofi
        ];
        text = ''
          mapfile -t out_names < <(wlr-randr --json | jq -r '.[] | select(.enabled) | .name')
          mapfile -t win_ids < <(lswt -j | jq -r '.toplevels[].identifier')
          mapfile -t win_labels < <(lswt -j | jq -r '.toplevels[] | "\(."app-id"): \(.title)"')

          labels=()
          raws=()
          for name in "''${out_names[@]}"; do
            labels+=("Entire screen — $name")
            raws+=("Monitor: $name")
          done
          for i in "''${!win_ids[@]}"; do
            labels+=("Window — ''${win_labels[$i]}")
            raws+=("Window: ''${win_ids[$i]}")
          done

          idx=$(printf '%s\n' "''${labels[@]}" | rofi -dmenu -p 'Share' -format i) || exit 0
          [ -n "$idx" ] && echo "''${raws[$idx]}"
        '';
      };
    in
    {
      imports = [
        inputs.self.modules.generic.xdg
      ];

      xdg.portal.wlr.settings.screencast = {
        chooser_type = "simple";
        chooser_cmd = "${xdpwChooser}/bin/xdpw-chooser";
        # Intel Arrow Lake-U (i915) exposes GPU-composited surfaces (e.g.Firefox)
        # as dmabufs with implicit/tiled modifiers that wlr-screencopy can't read
        # directly, producing a black frame instead of an error.
        # Forcing linear buffers trades a bit of capture performance for correctness.
        force_mod_linear = true;
      };
    };

  flake.homeModules.xdg = {
    imports = [
      inputs.self.modules.generic.xdg
    ];
  };
}
