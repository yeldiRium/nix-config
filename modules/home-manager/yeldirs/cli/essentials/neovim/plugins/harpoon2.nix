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
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin harpoon2 to work";
      }
    ];

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

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            for i = 1, 9, 1 do
              vim.keymap.set("n", "<C-"..i..">", function() harpoon:list():select(i) end)
              vim.keymap.set("n", "<C-k"..i..">", function() harpoon:list():select(i) end)
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
