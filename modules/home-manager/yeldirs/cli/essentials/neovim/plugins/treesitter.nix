{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.treesitter;
  supportedLanguages = config.yeldirs.cli.essentials.neovim.supportedLanguages;

  forLanguage = language: list: lib.optionals (lib.elem language supportedLanguages) list;
in {
  options = {
    yeldirs.cli.essentials.neovim.treesitter.enable = lib.mkEnableOption "neovim plugin treesitter";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins;
      [
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config =
            /*
            lua
            */
            ''
              require("nvim-treesitter.configs").setup({
                  indent = {
                      enable = true
                  },
                  highlight = {
                      enable = true,
                  },
              })

              vim.opt.foldmethod = "expr"
              vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
              vim.opt.foldlevel = 99
            '';
        }
      ]
      ++ (forLanguage "poefilter" [
        nvim-treesitter-parsers.poe_filter
      ])
      ++ (forLanguage "bash" [
        nvim-treesitter-parsers.bash
      ])
      ++ (forLanguage "go" [
        nvim-treesitter-parsers.go
        nvim-treesitter-parsers.gomod
        nvim-treesitter-parsers.gosum
      ])
      ++ (forLanguage "javascript" [
        nvim-treesitter-parsers.javascript
      ])
      ++ (forLanguage "typescript" [
        nvim-treesitter-parsers.typescript
      ])
      ++ (forLanguage "ledger" [
        {
          plugin = nvim-treesitter-parsers.ledger;
          type = "lua";
          config =
            /*
            lua
            */
            ''
              vim.filetype.add({
                  extension = {
                      prices = "ledger",
                  },
              })
            '';
        }
      ])
      ++ (forLanguage "lua" [
        nvim-treesitter-parsers.lua
      ])
      ++ (forLanguage "markdown" [
        nvim-treesitter-parsers.markdown
      ])
      ++ (forLanguage "nix" [
        nvim-treesitter-parsers.nix
      ])
      ++ (forLanguage "rego" [
        nvim-treesitter-parsers.rego
      ])
      ++ (forLanguage "yaml" [
        nvim-treesitter-parsers.yaml
      ]);
  };
}
