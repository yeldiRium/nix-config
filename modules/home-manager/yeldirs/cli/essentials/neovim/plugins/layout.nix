{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.layout;
in
{
  options = {
    yeldirs.cli.essentials.neovim.layout = {
      indentation-guides.enable = lib.mkEnableOption "neovim indentation guides";
    };
  };

  config = {
    programs.neovim = {
      extraLuaConfig =
        # lua
        ''
          vim.opt.number = true
          vim.opt.relativenumber = true

          vim.opt.tabstop = 4
          vim.opt.softtabstop = 4
          vim.opt.shiftwidth = 4
          vim.opt.expandtab = true

          vim.opt.smartindent = true

          vim.opt.wrap = false

          -- Fixed width 3 sign column
          vim.opt.signcolumn = "yes:3"

          vim.o.list = true
          vim.o.listchars = "tab:│->,space:·,lead:·,trail:·,eol:¬"

          vim.o.conceallevel = 0

          vim.opt.sidescrolloff = 10

          vim.opt.cursorline = true
          vim.opt.cursorcolumn = true

          vim.opt.winborder = "rounded"
        '';

      plugins =
        with pkgs.unstable.vimPlugins;
        [
          {
            plugin = lualine-nvim;
            type = "lua";
            config =
              # lua
              ''
                -- Below config assumes that
                -- - debugmaster.nvim is installed and used for debug mode
                local function lualineCwd()
                  return vim.fs.basename(vim.uv.cwd())
                end

                local debugmode = false
                vim.api.nvim_create_autocmd("User", {
                  pattern = "DebugModeChanged",
                  callback = function(args)
                    debugmode = args.data.enabled
                  end
                })

                require("lualine").setup({
                  sections = {
                    lualine_a = {
                      {
                        "mode",
                        fmt = function(str) return debugmode and "DEBUG" or str end,
                        -- TODO: Renable when https://github.com/nvim-lualine/lualine.nvim/issues/1424 is fixed
                        -- color = function(tb)
                        --   value = {}
                        --   if debugmode then
                        --     value.bg = "#2da84f"
                        --   end
                        --   return value
                        -- end,
                      },
                    },
                    -- TODO: Renable when https://github.com/nvim-lualine/lualine.nvim/issues/1424 is fixed
                    -- lualine_b = {
                    --   {
                    --     "branch", "diff", "diagnostics",
                    --     color = function(tb)
                    --       value = {}
                    --       if debugmode then
                    --         value.fg =  "#2da84f"
                    --       end
                    --       return value
                    --     end,
                    --   },
                    -- },
                    lualine_c = {
                      { "filename",
                        path = 1 }
                    },
                    lualine_z = {
                      "location",
                      lualineCwd
                    },
                  },
                })
              '';
          }
        ]
        ++ (lib.optionals cfg.indentation-guides.enable [
          {
            plugin = indent-blankline-nvim;
            type = "lua";
            config =
              # lua
              ''
                require("ibl").setup()
              '';
          }
        ]);
    };
  };
}
