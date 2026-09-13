# Language servers: go to definition, hover docs, rename, code actions, inline errors and inlay type hints.
{
  flake.nixvimModules.neovim =
    { pkgs, ... }:
    {
      # nvim-lspconfig: supplies each server's default command, file types and project-root detection
      plugins.lspconfig.enable = true;

      # Diagnostics: errors and warnings printed at the end of the offending line
      diagnostic.settings = {
        virtual_text = true;
        severity_sort = true;
        float.border = "rounded";
      };

      lsp = {
        inlayHints.enable = true; # Inline type and parameter-name hints

        # Added in any buffer with a language server; the rest (grn, gra, grr, gri, grt, gO) are Neovim defaults
        keymaps = [
          {
            key = "gd";
            lspBufAction = "definition";
            options.desc = "Go to definition";
          }
          {
            key = "gD";
            lspBufAction = "declaration";
            options.desc = "Go to declaration";
          }
          {
            # Overrides Neovim's plain-text default hover with lspsaga's bordered, markdown-rendered popup
            key = "K";
            action = "<CMD>Lspsaga hover_doc<CR>";
            options.desc = "Hover docs";
          }
        ];

        servers = {
          # Python: types, completion and inlay hints; picks up ./.venv on its own
          basedpyright = {
            enable = true;
            config.settings.basedpyright.analysis = {
              typeCheckingMode = "standard";
              inlayHints = {
                variableTypes = true;
                callArgumentNames = true;
                functionReturnTypes = true;
              };
            };
          };

          # Python: ruff lint warnings and quick fixes
          ruff.enable = true;

          # Rust; placed last on PATH so a project's own rust-analyzer, matching its toolchain, wins
          rust_analyzer = {
            enable = true;
            packageFallback = true;
            config.settings."rust-analyzer".check.command = "clippy";
          };

          # Nix, with completion for this flake's NixOS and home-manager options
          nixd = {
            enable = true;
            config.settings.nixd =
              let
                flake = ''(builtins.getFlake (toString ./.))'';
                hostname = ''(builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile "/etc/hostname"))'';
              in
              {
                nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
                options = {
                  nixos.expr = "${flake}.nixosConfigurations.${hostname}.options";
                  home-manager.expr = "${flake}.homeConfigurations.${hostname}.options";
                };
              };
          };

          # TypeScript and JavaScript, with parameter and type hints
          vtsls = {
            enable = true;
            config.settings =
              let
                inlayHints = {
                  parameterNames.enabled = "literals";
                  variableTypes.enabled = true;
                  functionLikeReturnTypes.enabled = true;
                  propertyDeclarationTypes.enabled = true;
                };
              in
              {
                typescript = { inherit inlayHints; };
                javascript = { inherit inlayHints; };
              };
          };

          # Typst; typstyle doubles as its formatter
          tinymist = {
            enable = true;
            config.settings.formatterMode = "typstyle";
          };

          terraformls.enable = true; # Terraform / OpenTofu (.tf, .tfvars)
          taplo.enable = true; # TOML
          jsonls.enable = true; # JSON, with schemas from SchemaStore
          yamlls.enable = true; # YAML, with schemas from SchemaStore
          bashls.enable = true; # Bash and sh
          marksman.enable = true; # Markdown links and headings
          dockerls.enable = true; # Dockerfile
          docker_compose_language_service.enable = true; # compose.yaml
          clangd.enable = true; # C and C headers
          texlab.enable = true; # LaTeX
        };
      };

      extraPackages = with pkgs; [
        shellcheck # Bash linter that bashls runs behind the scenes
      ];

      # schemastore: a catalogue of JSON/YAML schemas (package.json, GitHub workflows, docker-compose, ...) for validation and completion
      plugins.schemastore = {
        enable = true;
        json.enable = true;
        yaml.enable = true;
      };

      # crates: in Cargo.toml, shows the latest version of each dependency and offers upgrades
      plugins.crates.enable = true;

      # trouble: a Problems panel listing every error and warning
      plugins.trouble.enable = true;

      # lspsaga: prettier LSP popups (rounded border, icons, markdown rendering) than Neovim's default
      plugins.lspsaga = {
        enable = true;
        settings.ui.border = "rounded";
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>xx";
          action = "<cmd>Trouble diagnostics toggle<CR>";
          options.desc = "Problems (project)";
        }
        {
          mode = "n";
          key = "<leader>xb";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
          options.desc = "Problems (this file)";
        }
        {
          mode = "n";
          key = "<leader>xq";
          action = "<cmd>Trouble qflist toggle<CR>";
          options.desc = "Quickfix list";
        }
        # Lua one-liners: Neovim has no Ex command for these toggles
        {
          mode = "n";
          key = "<leader>uh";
          action.__raw = "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end";
          options.desc = "Toggle inlay hints";
        }
        {
          mode = "n";
          key = "<leader>ud";
          action.__raw = "function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end";
          options.desc = "Toggle diagnostics";
        }
      ];
    };
}
