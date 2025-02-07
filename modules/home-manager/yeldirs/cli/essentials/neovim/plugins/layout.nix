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
          vim.o.listchars = 'tab:▎»,space:·,lead:·,trail:·,eol:¬'

          vim.o.conceallevel = 1
        '';

      plugins = with pkgs.unstable.vimPlugins;
        []
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
