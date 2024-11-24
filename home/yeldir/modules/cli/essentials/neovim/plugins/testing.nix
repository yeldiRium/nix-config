{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.testing;
  supportedLanguages = config.yeldirs.cli.essentials.neovim.supportedLanguages;

  languageActive = language: lib.elem language supportedLanguages;
  optionals = language: list: lib.optionals (languageActive language) list;
in {
  options = {
    yeldirs.cli.essentials.neovim.testing.enable = lib.mkEnableOption "neovim test runner support";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the test runner support to work";
      }
      {
        assertion = config.yeldirs.cli.essentials.neovim.treesitter.enable;
        message = "neovim plugin treesitter must be enabled for the test runner support to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins;
      [
        nvim-nio
        {
          plugin = neotest;
          type = "lua";
          config =
            /*
            lua
            */
            ''
              local neotest = require("neotest")

              neotest.setup({
                adapters = {
                  ${
                if languageActive "go"
                then
                  /*
                  lua
                  */
                  ''
                    require("neotest-go"),
                  ''
                else ""
              }
                },
              })

              vim.keymap.set("n", "<leader>ctt", neotest.summary.toggle)
              vim.keymap.set("n", "<leader>ctn", neotest.run.run)
              vim.keymap.set("n", "<leader>cta", function () neotest.run.run(vim.fn.expand("%")) end)
              vim.keymap.set("n", "<leader>cto", neotest.output.open)
              vim.keymap.set("n", "<leader>cts", neotest.run.stop)
            '';
        }
      ]
      ++ (optionals "go" [
        neotest-go
      ]);
  };
}
