{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.testing;
  supportedLanguages = config.yeldirs.cli.essentials.neovim.supportedLanguages;

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
          # Upgrade to pkgs.unstable.vimPlugins.neotest once they have a working
          # release again
          # https://github.com/nvim-neotest/neotest/issues/530
          plugin = pkgs.vimPlugins.neotest;
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
                        require("neotest-golang"),
                      ''
                    else
                      ""
                  }
                  ${
                    if isLanguageSupported "rust" then
                      # lua
                      ''
                        require("neotest-rust"),
                      ''
                    else
                      ""
                  }
                },
              })

              vim.keymap.set("n", "<leader>ctt", neotest.summary.toggle, { desc = "Open test sidebar" })
              vim.keymap.set("n", "<leader>ctn", neotest.run.run, { desc = "Run the closest test" })
              vim.keymap.set("n", "<leader>cta", function () neotest.run.run(vim.fn.expand("%")) end, { desc = "Run all tests" })
              vim.keymap.set("n", "<leader>cto", neotest.output.open, { desc = "Open test output" })
              vim.keymap.set("n", "<leader>cts", neotest.run.stop, { desc = "Stop running tests" })
            '';
        }
      ]
      ++ (forLanguage "go" [
        pkgs.vimPlugins.neotest-golang
      ])
      ++ (forLanguage "rust" [
        pkgs.vimPlugins.neotest-rust
      ]);
  };
}
