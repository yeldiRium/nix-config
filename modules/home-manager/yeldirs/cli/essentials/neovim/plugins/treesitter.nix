{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.yeldirs.cli.essentials.neovim) supportedLanguages;
  cfg = config.yeldirs.cli.essentials.neovim.treesitter;

  forLanguage = language: list: lib.optionals (lib.elem language supportedLanguages) list;
in
{
  options = {
    yeldirs.cli.essentials.neovim.treesitter.enable = lib.mkEnableOption "neovim plugin treesitter";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tree-sitter
      gcc
    ];

    programs.neovim.plugins =
      with pkgs.vimPlugins;
      [
        {
          plugin = nvim-treesitter;
          type = "lua";
          config =
            # lua
            ''
              local treesitter = require("nvim-treesitter")

              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

              vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
              vim.o.foldmethod = 'expr'
              vim.o.foldlevel = 99
            '';
        }
      ]
      ++ (forLanguage "poefilter" [
        {
          plugin = nvim-treesitter.grammarPlugins.poe_filter;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "poefilter"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "poefilter" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "bash" [
        {
          plugin = nvim-treesitter.grammarPlugins.bash;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "bash"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "bash", "sh" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "css" [
        nvim-treesitter-parsers.css
        {
          plugin = nvim-treesitter.grammarPlugins.css;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "css"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "css" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "go" [
        {
          plugin = nvim-treesitter.grammarPlugins.go;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "go"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "go" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
        {
          plugin = nvim-treesitter.grammarPlugins.gomod;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "gomod"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "gomod" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
        {
          plugin = nvim-treesitter.grammarPlugins.gosum;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "gosum"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "gosum" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "html" [
        {
          plugin = nvim-treesitter.grammarPlugins.html;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "html"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "html", "htmx", "html5" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "javascript" [
        {
          plugin = nvim-treesitter.grammarPlugins.javascript;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "javascript"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "javascript" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "typescript" [
        {
          plugin = nvim-treesitter.grammarPlugins.typescript;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "typescript"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "typescript" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "lua" [
        {
          plugin = nvim-treesitter.grammarPlugins.lua;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "lua"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "lua" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "markdown" [
        {
          plugin = nvim-treesitter.grammarPlugins.markdown;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "markdown"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "markdown" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
        {
          plugin = nvim-treesitter.grammarPlugins.markdown_inline;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "markdown_inline"
              })
            '';
        }
      ])
      ++ (forLanguage "nix" [
        {
          plugin = nvim-treesitter.grammarPlugins.nix;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "nix"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "nix" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "python" [
        {
          plugin = nvim-treesitter.grammarPlugins.python;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "python"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "py" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "rego" [
        {
          plugin = nvim-treesitter.grammarPlugins.rego;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "rego"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "rego" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "tofu" [
        nvim-treesitter-parsers.hcl
        {
          plugin = nvim-treesitter-parsers.hcl;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "hcl"
              })

              vim.filetype.add({
                extension = {
                  tf = "opentofu",
                },
              })
              vim.filetype.add({
                extension = {
                  alloy = "alloy",
                },
              })
              vim.treesitter.language.register("hcl", "opentofu")
              vim.treesitter.language.register("hcl", "opentofu-vars")
              vim.treesitter.language.register("hcl", "terraform")
              vim.treesitter.language.register("hcl", "alloy")

              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "tofu", "tf", "alloy", "hcl" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "yaml" [
        {
          plugin = nvim-treesitter.grammarPlugins.yaml;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "yaml"
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "yaml" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ])
      ++ (forLanguage "ledger" [
        {
          plugin = nvim-treesitter.grammarPlugins.ledger;
          type = "lua";
          config =
            # lua
            ''
              treesitter.install({
                "ledger"
              })
              vim.filetype.add({
                extension = {
                  prices = "ledger",
                },
              })
              vim.api.nvim_create_autocmd("FileType", {
                pattern = { "ledger", "prices" },
                callback = function() vim.treesitter.start() end,
              })
            '';
        }
      ]);
  };
}
