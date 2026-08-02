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
          pyright-lsp = officialPlugin "pyright-lsp"; # Python language server
          rust-analyzer-lsp = officialPlugin "rust-analyzer-lsp"; # Rust language server
          typescript-lsp = officialPlugin "typescript-lsp"; # TypeScript language server
          pr-review-toolkit = officialPlugin "pr-review-toolkit"; # PR review agents
          commit-commands = officialPlugin "commit-commands"; # /commit, /commit-push-pr
        };

        settings = {
          model = "opusplan";
          effortLevel = "high";
          theme = "dark";
          spinnerTipsEnabled = false;
          syntaxHighlightingDisabled = false;

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
    };
}
