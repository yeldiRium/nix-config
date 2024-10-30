{pkgs, ...}: {
    programs.neovim.plugins = with pkgs.vimPlugins; [
        {
            plugin = rnvimr;
            type = "lua";
            config = ''
                vim.keymap.set("n", "<leader>pv", ":RnvimrToggle<cr>")
            '';
        }
    ];
}
