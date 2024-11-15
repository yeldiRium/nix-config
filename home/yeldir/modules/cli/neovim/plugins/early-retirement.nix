{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.early-retirement;
in {
  options = {
    yeldirs.cli.neovim.early-retirement.enable = lib.mkEnableOption "neovim plugin early-retirement";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for the plugin early-retirement to work";
      }
    ];

    programs.neovim.plugins = with pkgs.vimExtraPlugins; [
      {
        plugin = nvim-early-retirement;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require("early-retirement").setup({
              retirementAgeMins = 0,
              minimumBufferNum = 1,
              ignoreVisibleBufs = true,
              notificationOnAutoClose = true,
              deleteBufferWhenFileDeleted = true,
              ignoreSpecialBuftypes = true,
              ignoreUnloadedBufs = true,
            })
          '';
      }
    ];
  };
}
