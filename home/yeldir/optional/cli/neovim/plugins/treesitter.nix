{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gcc
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    nvim-treesitter-parsers.go
    nvim-treesitter-parsers.gomod
    nvim-treesitter-parsers.gosum
    nvim-treesitter-parsers.javascript
    nvim-treesitter-parsers.typescript
    nvim-treesitter-parsers.ledger
    nvim-treesitter-parsers.lua
    nvim-treesitter-parsers.markdown
    nvim-treesitter-parsers.nix
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

          vim.filetype.add({
              extension = {
                  prices = "ledger",
              },
          })
        '';
    }
  ];
}
