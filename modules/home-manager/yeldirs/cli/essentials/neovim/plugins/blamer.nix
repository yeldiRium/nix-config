{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.blamer;
in
{
  options = {
    yeldirs.cli.essentials.neovim.blamer.enable = lib.mkEnableOption "neovim plugin blamer";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = blamer-nvim;
        type = "lua";
        config =
          # lua
          ''
            vim.g.blamer_enabled = false

            vim.keymap.set("n", "<leader>gb", function()
              vim.cmd("BlamerToggle")
            end, { desc = "Toggle Blamer plugin for inline git blame" })
          '';
      }
    ];
  };
}
