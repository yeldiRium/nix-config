{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli) essentials;
in
{
  config = lib.mkIf essentials.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = fidget-nvim;
        type = "lua";
        config =
          # lua
          ''
            require("fidget").setup({
              notification = {
                override_vim_notify = true,
              },
            })
          '';
      }
    ];
  };
}
