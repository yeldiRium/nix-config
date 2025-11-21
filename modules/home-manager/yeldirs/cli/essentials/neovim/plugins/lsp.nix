{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli.essentials.neovim) supportedLanguages;
  cfg = config.yeldirs.cli.essentials.neovim.lsp;

  isLanguageSupported = language: lib.elem language supportedLanguages;
  forLanguagesList = languages: list: lib.optionals (lib.any isLanguageSupported languages) list;
  forLanguagesString =
    languages: string: lib.optionalString (lib.any isLanguageSupported languages) string;
in
{
  options = {
    yeldirs.cli.essentials.neovim.lsp.enable = lib.mkEnableOption "neovim lsp support";
  };
  config = lib.mkIf cfg.enable {
    # LSP servers
    home.packages =
      with pkgs;
      (forLanguagesList
        [ "bash" ]
        [
          nodePackages.bash-language-server
        ]
      )
      ++ (forLanguagesList
        [ "docker" ]
        [
          docker-compose-language-service
          dockerfile-language-server-nodejs
        ]
      )
      ++ (forLanguagesList
        [ "go" ]
        [
          gopls
          y.golangci-lint-langserver
        ]
      )
      ++ (forLanguagesList
        [ "javascript" "typescript" ]
        [
          nodePackages.typescript-language-server
        ]
      )
      ++ (forLanguagesList
        [ "json" ]
        [
          vscode-langservers-extracted
        ]
      )
      ++ (forLanguagesList
        [ "ledger" ]
        [
          y.hledger-language-server
        ]
      )
      ++ (forLanguagesList
        [ "lua" ]
        [
          lua-language-server
        ]
      )
      ++ (forLanguagesList
        [ "nix" ]
        [
          unstable.nixd
        ]
      )
      ++ (forLanguagesList
        [ "python" ]
        [
          python313Packages.python-lsp-server
        ]
      )
      ++ (forLanguagesList
        [ "rego" ]
        [
          regols
        ]
      )
      ++ (forLanguagesList
        [ "rust" ]
        [
          rust-analyzer
          rustfmt
        ]
      )
      ++ (forLanguagesList
        [ "tofu" ]
        [
          opentofu-ls
        ]
      )
      ++ (forLanguagesList
        [ "yaml" ]
        [
          yaml-language-server
        ]
      );

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      # LSP client configuration
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = lib.concatLines [
          # lua
          ''
            function add_lsp(name, options)
              if not options["capabilities"] then
                options["capabilities"] = {}
              end
              options["capabilities"] = vim.tbl_extend("keep",
                options["capabilities"],
                require("cmp_nvim_lsp").default_capabilities()
              )

              vim.lsp.enable(name)
              vim.lsp.config(name, options)
            end
          ''
          (forLanguagesString [ "bash" ] # lua
            ''
              add_lsp("bashls", {})
            ''
          )
          (forLanguagesString [ "docker" ] # lua
            ''
              add_lsp("docker_compose_language_service", {})
              add_lsp("dockerls", {})
            ''
          )
          (forLanguagesString [ "go" ] # lua
            ''
              if vim.fn.executable("go") == 1 then
                add_lsp("gopls", {})
              else
                -- TODO: inform the user that go language support is degraded
                --       but only do so if go language support is actually required, e.g. when a .go file is opened
              end
              if vim.fn.executable("golangci-lint") == 1 then
                add_lsp("golangci_lint_ls", {})
              else
                -- TODO: inform the user that go linter support is degraded
                --       but only do so if go linter support is actually required, e.g. when a .go file is opened
              end
            ''
          )
          (forLanguagesString [ "ledger" ] # lua
            ''
              add_lsp("hledger_ls", {
                -- production:
                -- cmd = { "${lib.getExe pkgs.y.hledger-language-server}" },
                -- development:
                cmd = { "/home/yeldir/querbeet/workspace/private/projects/hledger-language-server/hledger-language-server" },
                filetypes = { "ledger" },
                root_markers = { ".git" },
              })
            ''
          )
          (forLanguagesString [ "json" ] # lua
            ''
              add_lsp("jsonls", {})
            ''
          )
          (forLanguagesString [ "lua" ] # lua
            ''
              add_lsp("lua_ls", {
                settings = {
                  Lua = {
                    workspace = {
                      library = {
                        vim.env.VIMRUNTIME,
                      },
                    },
                  },
                },
              })
            ''
          )
          (forLanguagesString [ "nix" ] # lua
            ''
              add_lsp("nixd", {
                settings = { nixd = {
                  formatting = { command = { "nixfmt" }},
                  diagnostic = {
                    suppress = {
                      "sema-extra-with",
                    },
                  },
                }},
              })
            ''
          )
          (forLanguagesString [ "javascript" "typescript" ] # lua
            ''
              add_lsp("ts_ls", {})
            ''
          )
          (forLanguagesString [ "rego" ] # lua
            ''
              add_lsp("regols", {})
            ''
          )
          (forLanguagesString [ "rust" ] # lua
            ''
              local rustConfig = {}
              if vim.fn.executable("cargo-clippy") == 1 then
                rustConfig = {
                  settings = {
                    ['rust-analyzer'] = {
                      check = {
                        command = "clippy",
                      },
                    },
                  },
                }
              end

              add_lsp("rust_analyzer", rustConfig)
            ''
          )
          (forLanguagesString [ "tofu" ] # lua
            ''
              add_lsp("tofu_ls", {
                cmd = { "opentofu-ls", "serve" },
                filetypes = { "opentofu", "opentofu-vars", "terraform", "hcl" },
              })
            ''
          )
          (forLanguagesString [ "yaml" ] # lua
            ''
              add_lsp("yamlls", {
                settings = {
                  yaml = {
                    schemas = {
                      ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                      ["https://taskfile.dev/schema.json"] = "/Taskfile.yaml",
                    }
                  }
                },
              })
            ''
          )
        ];
      }

      # Completion sources for nvim-cmp
      cmp-nvim-lsp # cmp source to access Neovim's LSP client
      cmp-path # cmp source for System paths
      otter-nvim # LSP for embedded languages

      # Completion engine that uses the client
      lspkind-nvim
      {
        plugin = nvim-cmp;
        type = "lua";
        config =
          # lua
          ''
            local cmp = require('cmp')
            local cmpEnabled = false

            cmp.setup({
              enabled = cmpEnabled,
              -- Put icons into completion suggestions
              formatting = {
                format = require('lspkind').cmp_format({
                  before = function (entry, vim_item)
                    return vim_item
                  end,
                }),
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-Up>"] = cmp.mapping.scroll_docs(-4),
                ["<C-Down>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-Esc>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true })
              }),
              sources = {
                { name = "otter" },
                { name = "nvim_lsp" },
                { name = "path" },
              },
            })

            vim.keymap.set("n", "<leader>clt", function()
              if cmpEnabled then
                require("cmp").setup({ enabled = false })
                print("cmp disabled")
              else
                require("cmp").setup({ enabled = true })
                print("cmp enabled")
              end
              cmpEnabled = not cmpEnabled
            end, { desc = "Toggle LSP autocompletion" })
          '';
      }
    ];
  };
}
