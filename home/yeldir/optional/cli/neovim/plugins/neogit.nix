{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = neogit;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          local neogit = require('neogit')
          neogit.setup({})

          vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>")
        '';
    }
  ];
}
