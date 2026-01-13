{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli.essentials.neovim) supportedLanguages;
  cfg = config.yeldirs.cli.essentials.neovim.testing;

  isLanguageSupported = language: lib.elem language supportedLanguages;
  forLanguage = language: list: lib.optionals (isLanguageSupported language) list;
in
{
  options = {
    yeldirs.cli.essentials.neovim.testing.enable = lib.mkEnableOption "neovim test runner support";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.plugins =
      with pkgs.unstable.vimPlugins;
      [
        nvim-nio
        plenary-nvim
        {
          plugin = neotest;
          type = "lua";
          config =
            # lua
            ''
              local neotest = require("neotest")

              neotest.setup({
                adapters = {
                  ${
                    if isLanguageSupported "go" then
                      # lua
                      ''
                        require("neotest-golang")({
                          runner = "gotestsum",
                        }),
                      ''
                    else
                      ""
                  }
                },
              })

              vim.keymap.set("n", "<leader>ctt", neotest.summary.toggle, { desc = "Open test sidebar" })
              vim.keymap.set("n", "<leader>ctn", neotest.run.run, { desc = "Run the closest test" })
              vim.keymap.set("n", "<leader>cta", function () neotest.run.run(vim.fn.expand("%")) end, { desc = "Run all tests" })
              vim.keymap.set("n", "<leader>cto", function()
                neotest.output.open({
                  enter = true,
                  auto_close = true,
                })
              end, { desc = "Open test output" })
              vim.keymap.set("n", "<leader>cts", neotest.run.stop, { desc = "Stop running tests" })
            '';
        }
      ]
      ++ (forLanguage "go" [
        neotest-golang
      ]);
  };
}
