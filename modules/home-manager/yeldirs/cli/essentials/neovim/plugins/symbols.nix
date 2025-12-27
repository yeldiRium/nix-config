{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.symbols;
in
{
  options = {
    yeldirs.cli.essentials.neovim.symbols.enable = lib.mkEnableOption "neovim plugin symbols";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.vimExtraPlugins; [
      {
        plugin = symbols-nvim;
        type = "lua";
        config =
          # lua
          ''
            local r = require("symbols.recipes")
            require("symbols").setup(
                r.DefaultFilters,
                r.AsciiSymbols
            )
            vim.keymap.set("n", "<leader>cs", "<cmd>Symbols<CR>")
            vim.keymap.set("n", "<leader>cS", "<cmd>SymbolsClose<CR>")
          '';
      }
    ];
  };
}
