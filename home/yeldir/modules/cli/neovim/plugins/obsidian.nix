{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.obsidian;
in {
  options = {
    yeldirs.cli.neovim.obsidian = {
      enable = lib.mkEnableOption "obsidian";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for the plugin obsidian to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = obsidian-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            require('obsidian').setup({
              workspaces = {
                {
                  name = "obsidian",
                  path = "~/querbeet/workspace/obsidian/",
                },
              },
              daily_notes = {
                folder = "daily/log",
                date_format = "%Y-%m-%d %A",
                template = "templates/daily.md",
              },
              templates = {
                folder = "templates",
              },
            })
          '';
      }
    ];
  };
}
