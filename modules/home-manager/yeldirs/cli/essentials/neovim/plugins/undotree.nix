{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials.neovim.undotree;

  undodir = ".local/share/nvim/undodir";
in
{
  options = {
    yeldirs.cli.essentials.neovim.undotree.enable = lib.mkEnableOption "neovim plugin undotree";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = undotree;
        type = "lua";
        config =
          # lua
          ''
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo-tree sidebar" })

            vim.g["undotree_HighlightChangedText"] = false

            vim.opt.swapfile = false
            vim.opt.backup = false
            vim.opt.undodir = "${config.home.homeDirectory}/${undodir}"
            vim.opt.undofile = true
          '';
      }
    ];

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          undodir
        ];
      };
    };
  };
}
