{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.illuminate;
in {
  options = {
    yeldirs.cli.essentials.neovim.illuminate.enable = lib.mkEnableOption "neovim plugin illuminate";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin illuminate to work";
      }
    ];

    home.packages = with pkgs; [
      ripgrep
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = vim-illuminate;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("illuminate").configure({})
          '';
      }
    ];
  };
}
