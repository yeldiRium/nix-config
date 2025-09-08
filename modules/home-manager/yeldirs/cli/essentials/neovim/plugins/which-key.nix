{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.which-key;
in
{
  options = {
    yeldirs.cli.essentials.neovim.which-key.enable = lib.mkEnableOption "neovim plugin which-key";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = which-key-nvim;
        type = "lua";
        config =
          # lua
          ''
            require("which-key").setup({
              preset = "modern",
              delay = 500,
              keys = {
                scroll_down = "<C-r>",
                scroll_up = "<C-t>",
              },
            })
          '';
      }
    ];
  };
}
