{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.treesitter;
  supportedLanguages = config.yeldirs.cli.essentials.neovim.supportedLanguages;

  optionals = language: list: lib.optionals (lib.elem language supportedLanguages) list;
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
      ++ (optionals "poefilter" [
        nvim-treesitter-parsers.poe_filter
      ])
      ++ (optionals "bash" [
        nvim-treesitter-parsers.bash
      ])
      ++ (optionals "go" [
        nvim-treesitter-parsers.go
        nvim-treesitter-parsers.gomod
        nvim-treesitter-parsers.gosum
      ])
      ++ (optionals "javascript" [
        nvim-treesitter-parsers.javascript
      ])
      ++ (optionals "typescript" [
        nvim-treesitter-parsers.typescript
      ])
      ++ (optionals "ledger" [
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
      ++ (optionals "lua" [
        nvim-treesitter-parsers.lua
      ])
      ++ (optionals "markdown" [
        nvim-treesitter-parsers.markdown
      ])
      ++ (optionals "nix" [
        nvim-treesitter-parsers.nix
      ])
      ++ (optionals "rego" [
        nvim-treesitter-parsers.rego
      ])
      ++ (optionals "yaml" [
        nvim-treesitter-parsers.yaml
      ]);
  };
}
