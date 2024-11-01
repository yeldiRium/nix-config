{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.telescope;
in {
  options = {
    yeldirs.cli.neovim.telescope.enable = lib.mkEnableOption "neovim plugin telescope";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for the plugin telescope to work";
      }
    ];

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
            vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Search files in pwd" })
            vim.keymap.set("n", "<C-o>", builtin.git_files, { desc = "Search files in current git project" })
            vim.keymap.set("n", "<leader>ps", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ")})
            end, { desc = "Grep pwd using telescope" })
            vim.keymap.set("n", "<leader>fr", require("telescope.builtin").registers, { desc = "Show register contents using telescope" })
          '';
      }
    ];
  };
}
