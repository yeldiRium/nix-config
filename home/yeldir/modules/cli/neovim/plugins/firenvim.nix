{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.firenvim;
in {
  options = {
    yeldirs.cli.neovim.firenvim = {
      enable = lib.mkEnableOption "firenvim";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for firenvim to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = firenvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            vim.g.firenvim_config = {
              localSettings = {
                ["https://www.google"] = {
                  takeover = "never",
                },
              },
            }

            vim.cmd({
              cmd = "call",
              args = { "firenvim#install(0)" },
              mods = {
                silent = true,
              },
            })
          '';
      }
    ];
  };
}
