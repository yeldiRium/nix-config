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
            gitsigns.setup({})

            vim.keymap.set("n", "<leader>gbb", function()
              vim.cmd("Gitsigns blame")
            end, { desc = "Open git blame buffer" })
            vim.keymap.set("n", "<leader>gbl", function()
              vim.cmd("Gitsigns blame_line")
            end, { desc = "Show git blame for current line" })
          '';
      }
    ];
  };
}
