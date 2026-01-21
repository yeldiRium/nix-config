{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.quickfilepicker;
in
{
  options = {
    yeldirs.cli.essentials.neovim.quickfilepicker = {
      harpoon2.enable = lib.mkEnableOption "neovim plugin harpoon2";
      grapple.enable = lib.mkEnableOption "neovim plugin grapple";
    };
  };
  config = {
    assertions = [
      {
        assertion = !(cfg.harpoon2.enable && cfg.grapple.enable);
        message = "Can not activate neovim plugins harpoon2 and grapple at the same time";
      }
    ];
    programs.neovim.plugins =
      with pkgs.unstable.vimPlugins;
      [
        (lib.mkIf cfg.harpoon2.enable {
          plugin = harpoon2;
          type = "lua";
          config =
            # lua
            ''
              local harpoon = require('harpoon')
              harpoon:setup({})

              vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end, { desc = "Harpoon: Add current file to shortcuts" })
              vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Show shortcuts" })
              for i = 1, 9, 1 do
                vim.keymap.set("n", "<M-"..i..">", function() harpoon:list():select(i) end, { desc = "Harpoon: Switch to shortcut "..i })
                vim.keymap.set("n", "<M-k"..i..">", function() harpoon:list():select(i) end, { desc = "Harpoon: Switch to shortcut "..i })
              end
            '';
        })
      ]
      ++ (lib.optionals cfg.grapple.enable [
        {
          plugin = nvim-web-devicons;
          type = "lua";
          config =
            # lua
            ''
              require("nvim-web-devicons").setup()
            '';
        }
        {
          plugin = grapple-nvim;
          type = "lua";
          config =
            # lua
            ''
              local grapple = require('grapple')
              grapple.setup({})

              vim.keymap.set("n", "<leader>ma", grapple.toggle, { desc = "Grapple: Toggle tag on current file" })
              vim.keymap.set("n", "<C-e>", grapple.toggle_tags, { desc = "Grapple: Show tags" })
              for i = 1, 9, 1 do
                vim.keymap.set("n", "<M-"..i..">", function() grapple.select({ index = i }) end, { desc = "Grapple: Switch to shortcut "..i })
                vim.keymap.set("n", "<M-k"..i..">", function() grapple.select({ index = i }) end, { desc = "Grapple: Switch to shortcut "..i })
              end
            '';
        }
      ]);

    home.persistence = {
      "/persist" = {
        directories = [
          (lib.mkIf cfg.harpoon2.enable ".local/share/nvim/harpoon")
          (lib.mkIf cfg.grapple.enable ".local/share/nvim/grapple")
        ];
      };
    };
  };
}
