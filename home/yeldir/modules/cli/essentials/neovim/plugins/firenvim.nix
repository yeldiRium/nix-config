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
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for firenvim to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = firenvim;
        type = "lua";
        config = let
          disabledSites = [
            "https://www.google"
            "https://docs.google"
            "https://regex101.com"
            "https://web.whatsapp.com"
            "https://www.youtube.com"
          ];
          localSettings = lib.concatMapStringsSep "\n" (siteName:
            /*
            lua
            */
            ''
              ["${siteName}"] = {
                priority = 99,
                takeover = "never",
              },
            '')
          disabledSites;
          /*
          lua
          */
        in ''
          vim.g.firenvim_config = {
            localSettings = {
              ${localSettings}
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
