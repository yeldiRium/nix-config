{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.undotree;

  undodir = ".local/share/nvim/undodir";
in {
  options = {
    yeldirs.cli.neovim.undotree.enable = lib.mkEnableOption "neovim plugin undotree";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for the plugin undotree to work";
      }
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = undotree;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

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
