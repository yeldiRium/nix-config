{pkgs, ...}: {
  home.packages = with pkgs; [
    # LSPs for Programming languages
    gopls
    lua-language-server
    nixd
    nodePackages.typescript-language-server
    vscode-langservers-extracted
  ];
  programs.neovim.plugins = with pkgs.vimPlugins; [
    otter-nvim # LSP for embedded languages

    # LSP client configuration
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          local lspconfig = require('lspconfig')
          function add_lsp(server, options)
            if not options["cmd"] then
              options["cmd"] = server["document_config"]["default_config"]["cmd"]
            end
            if not options["capabilities"] then
              options["capabilities"] = {}
            end
            options["capabilities"] = vim.tbl_extend("keep",
              options["capabilities"],
              require("cmp_nvim_lsp").default_capabilities()
            )

            if vim.fn.executable(options["cmd"][1]) == 1 then
              server.setup(options)
            end
          end

          add_lsp(lspconfig.gopls, {})
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
          add_lsp(lspconfig.nixd, {
            settings = { nixd = {
              formatting = { command = { "alejandra" }},
            }},
          })
          add_lsp(lspconfig.tsserver, {})
        '';
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
          cmp.setup({
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
                  ["<Tab>"] = cmp.mapping.confirm({ select = true })
              }),
              sources = {
                  { name = "otter" },
                  { name = "nvim_lsp" },
                  { name = "luasnip" },
                  { name = "path" },
              },
          })
        '';
    }
  ];
}
