{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.harpoon2;
in {
  options = {
    yeldirs.cli.neovim.harpoon2.enable = lib.mkEnableOption "neovim plugin harpoon2";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
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
            vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)
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
