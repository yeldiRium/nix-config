{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.git;
in {
  options = {
    yeldirs.cli.essentials.neovim.git.enable = lib.mkEnableOption "neovim git support";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      nvim-web-devicons
      {
        plugin = diffview-nvim;
        type = "lua";
        config = /* lua */ ''
          require("diffview").setup({
            keymaps = {
              view = {
                { "n", "<C-c>", function() vim.cmd("DiffviewClose") end },
              },
              file_panel = {
                { "n", "<C-c>", function() vim.cmd("DiffviewClose") end },
              },
            },
          })
          '';
      }
      {
        plugin = neogit;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local neogit = require('neogit')
            neogit.setup({
              mappings = {
                status = {
                  ["<C-c>"] = "Close",
                },
              },
            })

            vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open NeoGit" })
          '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local gitsigns = require("gitsigns")
            gitsigns.setup({})
          '';
      }
    ];
  };
}
