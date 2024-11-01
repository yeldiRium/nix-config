{
  config,
  pkgs,
  ...
}: let
  undodir = ".local/share/nvim/undodir";
in {
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
}
