{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.lsp;
  supportedLanguages = config.yeldirs.cli.essentials.neovim.supportedLanguages;

  languageActive = language: lib.elem language supportedLanguages;
  optionals = language: list: lib.optionals (languageActive language) list;
in {
  options = {
    yeldirs.cli.essentials.neovim.lsp.enable = lib.mkEnableOption "neovim lsp support";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the lsp support to work";
      }
    ];

    # LSP servers
    home.packages = with pkgs;
      (optionals "bash" [
        nodePackages.bash-language-server
      ])
      ++ (optionals "docker" [
        docker-compose-language-service
        dockerfile-language-server-nodejs
      ])
      ++ (optionals "go" [
        gopls
      ])
      ++ (optionals "javascript" [
        nodePackages.typescript-language-server
      ])
      ++ (optionals "json" [
        vscode-langservers-extracted
      ])
      ++ (optionals "ledger" [
        hledger-language-server
      ])
      ++ (optionals "lua" [
        lua-language-server
      ])
      ++ (optionals "nix" [
        unstable.nixd
      ])
      ++ (optionals "typescript" [
        nodePackages.typescript-language-server
      ])
      ++ (optionals "yaml" [
        yaml-language-server
      ]);

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      otter-nvim # LSP for embedded languages

      # LSP client configuration
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = lib.concatLines [
          /*
          lua
          */
          ''
            local lspconfig = require("lspconfig")
            local lspConfigurations = require("lspconfig.configs")

            function add_lsp(server, options)
              if not options["capabilities"] then
                options["capabilities"] = {}
              end
              options["capabilities"] = vim.tbl_extend("keep",
                options["capabilities"],
                require("cmp_nvim_lsp").default_capabilities()
              )

              server.setup(options)
            end
          ''
          (
            if languageActive "bash"
            then
              /*
              lua
              */
              ''
                add_lsp(lspconfig.bashls, {})
              ''
            else ""
          )
          (
            if languageActive "docker"
            then
              /*
              lua
              */
              ''
                add_lsp(lspconfig.docker_compose_language_service, {})
                add_lsp(lspconfig.dockerls, {})
              ''
            else ""
          )
          (
            if languageActive "go"
            then
              /*
              lua
              */
              ''
                add_lsp(lspconfig.gopls, {})
              ''
            else ""
          )
          (
            if languageActive "ledger"
            then
              /*
              lua
              */
              ''
                if not lspConfigurations.hledger_ls then
                  lspConfigurations.hledger_ls = {
                    default_config = {
                      -- production:
                      -- cmd = { "${lib.getExe pkgs.hledger-language-server}" },
                      -- development:
                      cmd = { "/home/yeldir/querbeet/workspace/private/projects/hledger-language-server/hledger-language-server" },
                      filetypes = { "ledger" },
                      root_dir = require("lspconfig.util").root_pattern(".git", "*.journal"),
                      settings = {},
                    },
                  }
                end

                add_lsp(lspconfig.hledger_ls, {})
              ''
            else ""
          )
          (
            if languageActive "json"
            then
              /*
              lua
              */
              ''
                add_lsp(lspconfig.jsonls, {
                  capabilities = {
                    textDocument = {
                      completion = {
                        completionItem = {
                          snippetSupport = true,
                        },
                      },
                    },
                  },
                })
              ''
            else ""
          )
          (
            if languageActive "lua"
            then
              /*
              lua
              */
              ''
                add_lsp(lspconfig.lua_ls, {
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
            else ""
          )
          (
            if languageActive "nix"
            then
              /*
              lua
              */
              ''
                add_lsp(lspconfig.nixd, {
                  settings = { nixd = {
                    formatting = { command = { "alejandra" }},
                    diagnostic = {
                      suppress = {
                        "sema-extra-with",
                      },
                    },
                  }},
                })
              ''
            else ""
          )
          (
            if languageActive "javascript" || languageActive "typescript"
            then
              /*
              lua
              */
              ''
                add_lsp(lspconfig.ts_ls, {})
              ''
            else ""
          )
          (
            if languageActive "yaml"
            then
              /*
              lua
              */
              ''
                add_lsp(lspconfig.yamlls, {
                  settings = {
                    yaml = {
                      schemas = {
                        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                      }
                    }
                  },
                })
              ''
            else ""
          )
        ];
      }

      # Completion sources for nvim-cmp
      cmp-nvim-lsp # cmp source to access Neovim's LSP client
      luasnip # Snippet support
      cmp-path # cmp source for System paths

      # Completion engine that uses the client
      lspkind-nvim
      {
        plugin = nvim-cmp;
        type = "lua";
        config =
          /*
          lua
          */
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
                snippet = {
                  expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                  end,
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
                    { name = "luasnip" },
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
            end, {})
          '';
      }
    ];
  };
}
