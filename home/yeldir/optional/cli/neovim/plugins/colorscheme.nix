{pkgs, ...}: {
    programs.neovim.plugins = with pkgs.vimPlugins; [
        {
            plugin = tokyonight-nvim;
            type = "lua";
            config = ''
                require("tokyonight").setup({
                    style = "night"
                })
                vim.cmd.colorscheme("tokyonight")
            '';
        }
    ];
}
