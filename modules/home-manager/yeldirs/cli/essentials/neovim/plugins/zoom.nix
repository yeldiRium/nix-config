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
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin zoom to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = zoomwintab-vim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            vim.keymap.set("n", "<leader>o", function()
              vim.cmd(":ZoomWinTabToggle")
            end)
          '';
      }
    ];
  };
}
