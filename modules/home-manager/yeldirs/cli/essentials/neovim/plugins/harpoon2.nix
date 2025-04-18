{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.harpoon2;
in {
  options = {
    yeldirs.cli.essentials.neovim.harpoon2.enable = lib.mkEnableOption "neovim plugin harpoon2";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = harpoon2;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local harpoon = require('harpoon')
            harpoon:setup({})

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: Add current file to shortcuts" })
            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Show shortcuts" })
            for i = 1, 9, 1 do
              vim.keymap.set("n", "<M-"..i..">", function() harpoon:list():select(i) end, { desc = "Harpoon: Switch to shortcut "..i })
              vim.keymap.set("n", "<M-k"..i..">", function() harpoon:list():select(i) end, { desc = "Harpoon: Switch to shortcut "..i })
            end
          '';
      }
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".local/share/nvim/harpoon"
        ];
      };
    };
  };
}
