{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.telescope;
in {
  options = {
    yeldirs.cli.essentials.neovim.telescope.enable = lib.mkEnableOption "neovim plugin telescope";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin telescope to work";
      }
    ];

    home.packages = with pkgs; [
      ripgrep
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = telescope-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("telescope").setup({})

            local telescope = require("telescope.builtin")
            vim.keymap.set("n", "<leader>pf", telescope.find_files, { desc = "Search files in pwd" })
            vim.keymap.set("n", "<C-o>", telescope.git_files, { desc = "Search files in current git project" })
            vim.keymap.set("n", "<leader>ps", function()
              telescope.grep_string({
                search = vim.fn.input("Grep > "),
                use_regex = true,
              })
            end, { desc = "Grep pwd using telescope" })
            vim.keymap.set("n", "<leader>fr", telescope.registers, { desc = "Show register contents using telescope" })
          '';
      }
    ];
  };
}
