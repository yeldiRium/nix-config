{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.zoom;
in {
  options = {
    yeldirs.cli.essentials.neovim.zoom.enable = lib.mkEnableOption "neovim plugin zoomwintab";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = zoomwintab-vim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            vim.keymap.set("n", "<leader>z", function()
              vim.cmd(":ZoomWinTabToggle")
            end, { desc = "Toggle fullscreen for window" })
          '';
      }
    ];
  };
}
