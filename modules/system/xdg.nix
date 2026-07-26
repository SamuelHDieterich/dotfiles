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
      # xdpw 0.8.3 shipped "screencast: drive the Pipewire graph by ourselves",
      # which upstream's own release notes warn "will sometimes stall screen recording" —
      # it freezes the stream after the first frame (Firefox/Meet).
      # 0.8.2 is the last good release. Pinned via overlay so it is globally used.
      # Drop once 0.8.4 lands in nixpkgs.
      nixpkgs.overlays = [
        (final: prev: {
          xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (old: {
            version = "0.8.2";
            src = prev.fetchFromGitHub {
              owner = "emersion";
              repo = "xdg-desktop-portal-wlr";
              rev = "v0.8.2";
              hash = "sha256-HITf/hgiASWvn/z49mzS8IS1vuyXwdk1JiAOOHRSQMo=";
            };
          });
        })
      ];

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

      # Builds a tabbed screen/window picker through rofi:
      # "screens" and "windows" are each a rofi script mode (see rofi-script(5)),
      # which is what gives rofi its mode-switcher tab bar.
      xdpwScreens = pkgs.writeShellApplication {
        name = "xdpw-screens";
        runtimeInputs = with pkgs; [
          wlr-randr
          jq
        ];
        text = builtins.readFile ./xdpw-chooser/screens.sh;
      };
      xdpwWindows = pkgs.writeShellApplication {
        name = "xdpw-windows";
        runtimeInputs = with pkgs; [
          lswt # Lists Wayland toplevels
          jq
        ];
        text = builtins.readFile ./xdpw-chooser/windows.sh;
      };
      # The launcher ties the two mode scripts above together into one tabbed rofi invocation.
      xdpwChooser = pkgs.writeShellApplication {
        name = "xdpw-chooser";
        runtimeInputs = with pkgs; [
          rofi
          coreutils # mktemp/cat/rm under xdpw's restricted PATH
        ];
        text = builtins.readFile ./xdpw-chooser/launcher.sh;
      };
    in
    {
      imports = [
        inputs.self.modules.generic.xdg
      ];

      xdg.portal.wlr.settings.screencast = {
        chooser_type = "simple";
        chooser_cmd = ''
          ${xdpwChooser}/bin/xdpw-chooser \
            --screens ${xdpwScreens}/bin/xdpw-screens \
            --windows ${xdpwWindows}/bin/xdpw-windows
        '';
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
