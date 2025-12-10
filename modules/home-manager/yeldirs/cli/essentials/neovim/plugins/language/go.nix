{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli.essentials.neovim) supportedLanguages;

  isLanguageSupported = language: lib.elem language supportedLanguages;
in
{
  config = lib.mkIf (isLanguageSupported "go") {
    programs.neovim.plugins = with pkgs.vimExtraPlugins; [
      {
        plugin = no-go-nvim;
        type = "lua";
        config =
          # lua
          ''
            require('no-go').setup({})
          '';
      }
    ];
  };
}
