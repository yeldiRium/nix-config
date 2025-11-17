{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.git;
in
{
  options = {
    yeldirs.cli.essentials.neovim.git.enable = lib.mkEnableOption "neovim git support";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config =
          # lua
          ''
            local gitsigns = require("gitsigns")
            gitsigns.setup({
              preview_config = {
                border = 'single',
              },
            })

            vim.keymap.set("n", "<leader>gbb", function()
              vim.cmd("Gitsigns blame")
            end, { desc = "Open git blame buffer" })
            vim.keymap.set("n", "<leader>gbl", function()
              vim.cmd("Gitsigns blame_line")
            end, { desc = "Show git blame for current line" })

            vim.keymap.set("n", "<leader>gdh", function()
              vim.cmd("Gitsigns diffthis HEAD")
            end, { desc = "Show diff of current buffer with HEAD" })

            vim.keymap.set("n", "<leader>ghp", function()
              vim.cmd("Gitsigns preview_hunk")
            end, { desc = "Show hunk preview in popup" })
          '';
      }
    ];
  };
}
