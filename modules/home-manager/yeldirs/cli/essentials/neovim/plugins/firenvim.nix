{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.firenvim;
in {
  options = {
    yeldirs.cli.essentials.neovim.firenvim = {
      enable = lib.mkEnableOption "firenvim";
    };
  };

  config = lib.mkIf cfg.enable {
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
                [".*"] = {
                  priority = 0,
                  takeover = "never",
                },
                ["https://github.com"] = {
                  priority = 90,
                  takeover = "always",
                  selector = 'textarea:not([readonly], [aria-readonly], [id="copilot-chat-textarea"]), div[role="textbox"]',
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
