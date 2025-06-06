{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.layout;
in {
  options = {
    yeldirs.cli.essentials.neovim.layout = {
      indentation-guides.enable = lib.mkEnableOption "neovim indentation guides";
    };
  };

  config = {
    programs.neovim = {
      extraLuaConfig =
        /*
        lua
        */
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
        '';

      plugins = with pkgs.unstable.vimPlugins;
        [
          {
            plugin = smear-cursor-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                require("smear_cursor").setup({
                  smear_insert_mode = false,

                  stiffness = 0.7,
                  trailing_stiffness = 0.4,
                })
              '';
          }
          {
            plugin = lualine-nvim;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                local function lualineCwd()
                  return vim.fs.basename(vim.uv.cwd())
                end
                require("lualine").setup({
                  sections = {
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
              /*
              lua
              */
              ''
                require("ibl").setup()
              '';
          }
        ]);
    };
  };
}
