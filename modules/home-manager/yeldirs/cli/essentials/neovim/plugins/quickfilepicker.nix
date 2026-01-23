{
  pkgs,
  ...
}:
{
  config = {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
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
      {
        plugin = snacks-nvim;
        type = "lua";
        config =
          # lua
          ''
            require("snacks").setup({})
          '';
      }
      {
        plugin = pkgs.vimExtraPlugins.seeker-nvim;
        type = "lua";
        config =
          # lua
          ''
            local seeker = require("seeker")
            seeker.setup({})
            vim.keymap.set("n", "<C-O>", function()
              seeker.seek()
            end, { desc = "Seeker: Qery for file" })
          '';
      }
    ];

    home.persistence = {
      "/persist" = {
        directories = [
          ".local/share/nvim/grapple"
        ];
      };
    };
  };
}
