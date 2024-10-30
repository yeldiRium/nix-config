{config, pkgs, ...}: let 
    undodir = "${config.home.homeDirectory}/.local/nvim/undodir";
in {
    programs.neovim.plugins = with pkgs.vimPlugins; [
        {
            plugin = undotree;
            type = "lua";
            config = /* lua */ ''
                vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

                vim.g["undotree_HighlightChangedText"] = false

                vim.opt.swapfile = false
                vim.opt.backup = false
                vim.opt.undodir = "${undodir}"
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
