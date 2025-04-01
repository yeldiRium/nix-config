{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.fidget;
in {
  options = {
    yeldirs.cli.essentials.neovim.fidget.enable = lib.mkEnableOption "neovim plugin fidget";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin fidget to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = fidget-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("fidget").setup()
          '';
      }
    ];
  };
}
