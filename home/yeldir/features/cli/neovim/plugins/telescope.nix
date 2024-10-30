{pkgs, ...}: {
  home.packages = with pkgs; [
    ripgrep
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = telescope-nvim;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          require("telescope").setup({})

          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
          vim.keymap.set("n", "<C-o>", builtin.git_files, {})
          vim.keymap.set("n", "<leader>ps", function()
              builtin.grep_string({ search = vim.fn.input("Grep > ")})
          end)
        '';
    }
  ];
}
