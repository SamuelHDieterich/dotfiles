{
  flake.homeModules.claudeCode =
    {
      lib,
      pkgs,
      inputs,
      ...
    }:
    let
      # Upstream ships a single bash script. Wrap it so jq is on PATH rather than
      # rebuilding it with writeShellApplication, which would inject its own
      # `set -euo pipefail` into a script not written for it.
      tokenline =
        pkgs.runCommand "tokenline"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
            meta.mainProgram = "tokenline";
          }
          ''
            install -Dm755 ${inputs.tokenline}/tokenline.sh $out/bin/tokenline

            # Claude Code sends rate_limits.*.resets_at as a raw epoch int, not the
            # ISO-8601 string tokenline's epoch_from_iso() expects, so the 5h/7d
            # reset countdown silently disappears. Use the value as-is when it's
            # already numeric, falling back to ISO parsing otherwise.
            substituteInPlace $out/bin/tokenline \
              --replace-fail \
                'rl_5h_reset=$(epoch_from_iso "''${_f[6]}")' \
                'rl_5h_reset="''${_f[6]}"; [[ "$rl_5h_reset" =~ ^[0-9]+$ ]] || rl_5h_reset=$(epoch_from_iso "$rl_5h_reset")' \
              --replace-fail \
                'rl_7d_reset=$(epoch_from_iso "''${_f[8]}")' \
                'rl_7d_reset="''${_f[8]}"; [[ "$rl_7d_reset" =~ ^[0-9]+$ ]] || rl_7d_reset=$(epoch_from_iso "$rl_7d_reset")'

            wrapProgram $out/bin/tokenline \
              --prefix PATH : ${
                lib.makeBinPath (
                  with pkgs;
                  [
                    bash # `#!/usr/bin/env bash`, needs 4+
                    jq
                    gawk
                    coreutils
                  ]
                )
              }
          '';

      officialPlugin = name: "${inputs.claude-plugins-official}/plugins/${name}";

      # The hooks' commands call bare `node`, which would depend on whatever
      # the host happens to have on PATH. Pin the interpreter instead.
      caveman = pkgs.runCommand "caveman-plugin" { } ''
        cp -r --no-preserve=mode,ownership ${inputs.caveman} $out

        substituteInPlace $out/.claude-plugin/plugin.json \
          --replace-fail '; node \"$HOOK_ROOT' '; ${lib.getExe pkgs.nodejs} \"$HOOK_ROOT'
      '';

      # Same issue as caveman: hooks call bare `python3`. Pin the interpreter.
      hookify = pkgs.runCommand "hookify-plugin" { } ''
        cp -r --no-preserve=mode,ownership ${officialPlugin "hookify"} $out

        substituteInPlace $out/hooks/hooks.json \
          --replace-fail '"command": "python3 ' '"command": "${lib.getExe' pkgs.python3 "python3"} '
      '';
    in
    {
      programs.claude-code = {
        enable = true;
        package = inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;

        context = ./CLAUDE.md;
        rulesDir = ./rules;

        skills = {
          python-stack = ./skills/python-stack;
          nix-dendritic = ./skills/nix-dendritic;
          devenv-workflow = ./skills/devenv-workflow;
          terraform = "${inputs.terraform-skill}/skills/terraform-skill";
          prompt-master = "${inputs.prompt-master}";
        };

        # Attribute names become the plugin directory names. A bare list would
        # derive them from store path basenames, which are unstable across bumps.
        plugins = {
          superpowers = "${inputs.superpowers}"; # Brainstorming, TDD, systematic debugging
          frontend-design = officialPlugin "frontend-design"; # Visual design guidance
          skill-creator = officialPlugin "skill-creator"; # Authoring and evaluating skills
          claude-md-management = officialPlugin "claude-md-management"; # Audit and refresh CLAUDE.md
          claude-security = officialPlugin "claude-security"; # On-demand vulnerability scan
          pr-review-toolkit = officialPlugin "pr-review-toolkit"; # PR review agents
          commit-commands = officialPlugin "commit-commands"; # /commit, /commit-push-pr
          caveman = caveman; # Ultra-compressed output mode
          hookify = hookify; # Author hooks from conversation patterns
        };

        # The marketplace's `*-lsp` plugin dirs are just README+LICENSE; the
        # real config lives in the manifest, which personal-plugin symlinks skip.
        # Declare the servers directly, pinned to store paths.
        lspServers = {
          pyright = {
            command = lib.getExe' pkgs.pyright "pyright-langserver";
            args = [ "--stdio" ];
            extensionToLanguage = {
              ".py" = "python";
              ".pyi" = "python";
            };
          };
          rust-analyzer = {
            command = lib.getExe' pkgs.rust-analyzer "rust-analyzer";
            extensionToLanguage = {
              ".rs" = "rust";
            };
          };
          typescript = {
            command = lib.getExe' pkgs.typescript-language-server "typescript-language-server";
            args = [ "--stdio" ];
            extensionToLanguage = {
              ".ts" = "typescript";
              ".tsx" = "typescriptreact";
              ".mts" = "typescript";
              ".cts" = "typescript";
              ".js" = "javascript";
              ".jsx" = "javascriptreact";
              ".mjs" = "javascript";
              ".cjs" = "javascript";
            };
          };
        };

        settings = {
          model = "opusplan";
          effortLevel = "high";
          promptCacheTtl = "1h";
          theme = "dark";
          spinnerTipsEnabled = false;
          syntaxHighlightingDisabled = false;
          includeCoAuthoredBy = false;

          statusLine = {
            type = "command";
            command = lib.getExe tokenline;
            refreshInterval = 1;
          };

          permissions = {
            # Destructive and irreversible.
            deny = [
              "Bash(git branch -D:*)"
              "Bash(git push --force:*)"
              "Bash(git reset --hard:*)"
              "Read(**/secrets/**)"
              "Read(**/.env)"
            ];
            # Recoverable, but mine to trigger.
            ask = [
              "Bash(nixos-rebuild:*)"
              "Bash(nh os:*)"
              "Bash(nh home:*)"
              "Bash(tofu apply:*)"
              "Bash(tofu destroy:*)"
              "Bash(terragrunt apply:*)"
              "Bash(terragrunt destroy:*)"
              "Bash(gcloud auth print-access-token:*)"
            ];
          };
        };
      };

      # Installed, but not automatic: without this the plugin turns caveman
      # on in every session of every repo. Opt a session in with
      # CAVEMAN_DEFAULT_MODE=full.
      xdg.configFile."caveman/config.json".source =
        (pkgs.formats.json { }).generate "caveman-config.json"
          {
            defaultMode = "off";
          };
    };
}
