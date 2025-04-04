{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.which-key;
in {
  options = {
    yeldirs.cli.essentials.neovim.which-key.enable = lib.mkEnableOption "neovim plugin which-key";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin which-key to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = which-key-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("which-key").setup({
              delay = 500,
            })
          '';
      }
    ];
  };
}
