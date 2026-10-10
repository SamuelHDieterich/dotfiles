# Claude Code multi-account support according to the directory `claude` is launched from.
#
# Each account is a separate CLAUDE_CONFIG_DIR, which isolates its login, history, projects and memory.
#
# 1. A launcher replaces the `claude` binary and sets CLAUDE_CONFIG_DIR from the current directory.
# 2. The files home-manager writes into ~/.claude are mirrored into every account's dir, so all accounts share one configuration.
# 3. Assertions catch the setups that would silently break 1 or 2.

{
  flake.homeModules.claudeCode =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      # Interface

      options.claudeCode.accounts = lib.mkOption {
        description = "Extra Claude Code accounts. Launching `claude` under one of an account's paths uses its config dir; everywhere else uses the default one.";
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                configDir = lib.mkOption {
                  type = lib.types.str;
                  default = "${config.home.homeDirectory}/.claude-${name}";
                  description = "Config dir (CLAUDE_CONFIG_DIR) holding this account's login, history and memory.";
                };
                paths = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  description = "Absolute directories where `claude` uses this account, subdirectories included.";
                };
              };
            }
          )
        );
        default = { };
      };

      config =
        let
          cfg = config.programs.claude-code;
          accounts = lib.attrValues config.claudeCode.accounts;

          # 1. Launcher
          #
          # The launcher is swapped into a copy of the upstream package so everything else (completions, version) stays as upstream ships it.

          # Not cfg.package: that option is set to the wrapper below, so reading it here would be infinite recursion.
          upstream = inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;

          # Every (path, configDir) pair across all accounts, longest path first.
          # The shell `case` stops at the first match, so the most specific path must come first; otherwise an account mapped to ~/A would shadow one mapped to ~/A/B.
          routes = lib.sort (a: b: lib.stringLength a.path > lib.stringLength b.path) (
            lib.concatMap (
              account:
              map (path: {
                inherit path;
                inherit (account) configDir;
              }) account.paths
            ) accounts
          );

          # One `case` arm per route, matching the directory itself or anything below it.
          caseArms = lib.concatMapStrings (route: ''
            ${lib.escapeShellArg route.path} | ${lib.escapeShellArg route.path}/*)
              export CLAUDE_CONFIG_DIR=${lib.escapeShellArg route.configDir}
              break
              ;;
          '') routes;

          launcher = pkgs.writeShellScript "claude-account-launcher" ''
            # A CLAUDE_CONFIG_DIR already in the environment wins, whether set by hand or inherited from a parent session.
            if [[ -z "''${CLAUDE_CONFIG_DIR:-}" ]]; then
              # Check both the logical and the physical cwd, so a mapped directory reached through a symlink still matches.
              for dir in "$PWD" "$(pwd -P)"; do
                case "$dir" in
                ${caseArms}
                esac
              done
            fi
            exec -a "$0" ${lib.getExe upstream} "$@"
          '';

          # The upstream package with bin/claude pointing at the launcher.
          # home-manager gates features on the package version, so the wrapper must keep it.
          # Upstream's meta is left out: its unfree license would fail evaluation in a pkgs without allowUnfree.
          wrapped = pkgs.symlinkJoin {
            name = "claude-code-${upstream.version}";
            inherit (upstream) version;
            meta.mainProgram = "claude";
            paths = [ upstream ];
            postBuild = ''
              rm $out/bin/claude
              ln -s ${launcher} $out/bin/claude
            '';
          };

          # 2. Shared configuration
          #
          # home-manager only writes into the default config dir.
          # Login, history, projects and skills Claude Code installs itself are not in the list, so they stay per account.

          # Mirrors home-manager's own condition for generating this plugin (LSP or MCP servers to carry, MCP integration included).
          hasGeneratedPlugin =
            cfg.lspServers != { }
            || cfg.mcpServers != { }
            || (cfg.enableMcpIntegration && config.programs.mcp.enable && config.programs.mcp.servers != { });

          # Listed from home-manager's options rather than read from home.file, because deriving home.file keys from home.file is infinite recursion.
          mirroredEntries = [
            "settings.json"
            "CLAUDE.md"
            "rules"
          ]
          ++ map (name: "skills/${name}") (
            lib.attrNames cfg.skills
            ++ lib.attrNames cfg.plugins
            ++ lib.optional hasGeneratedPlugin "claude-code-home-manager"
          );

          # The home.file entries for one account.
          accountFiles =
            account:
            lib.listToAttrs (
              map (
                entry:
                lib.nameValuePair "${account.configDir}/${entry}" {
                  inherit (config.home.file."${cfg.configDir}/${entry}") source recursive;
                }
              ) mirroredEntries
            )
            // {
              # IDE integrations write their lock files to the default config dir; without this link `/ide` finds no IDE from another account.
              "${account.configDir}/ide".source = config.lib.file.mkOutOfStoreSymlink "${cfg.configDir}/ide";
            };

          # 3. Drift detection
          #
          # Whatever home-manager writes into the default config dir that mirroredEntries misses.
          # Assertions may read home.file without recursion, so this is where a new upstream option gets caught.

          isMirrored =
            key:
            lib.any (
              entry: key == "${cfg.configDir}/${entry}" || lib.hasPrefix "${cfg.configDir}/${entry}/" key
            ) mirroredEntries;

          unmirrored = lib.filter (key: lib.hasPrefix "${cfg.configDir}/" key && !isMirrored key) (
            lib.attrNames config.home.file
          );
        in
        # Without accounts the launcher would only add a layer, and the assertions would restrict configDir for nothing.
        lib.mkIf (accounts != [ ]) (
          let
            defaultConfigDir = "${config.home.homeDirectory}/.claude";
          in
          {
            programs.claude-code.package = wrapped;

            home.file = lib.mkMerge (map accountFiles accounts);

            assertions = [
              {
                # A relocated default dir makes home-manager export CLAUDE_CONFIG_DIR globally, which the launcher would treat as an override and never switch accounts.
                assertion = cfg.configDir == defaultConfigDir;
                message = "claude-code accounts: programs.claude-code.configDir must stay at ${defaultConfigDir}.";
              }
              {
                # Without this check, a new home-manager option (agents, commands, hooks…) would silently exist only in the default account.
                assertion = unmirrored == [ ];
                message = "claude-code accounts: home-manager writes ${lib.concatStringsSep ", " unmirrored}, which is not mirrored into the other accounts. Add it to mirroredEntries in accounts.nix.";
              }
            ];
          }
        );
    };
}
