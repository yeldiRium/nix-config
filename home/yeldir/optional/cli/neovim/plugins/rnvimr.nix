{pkgs, ...}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = rnvimr;
      type = "lua";
      config =
        /*
        lua
        */
        ''
          vim.keymap.set("n", "<leader>pv", ":RnvimrToggle<cr>")

          -- Replace netrw
          vim.g["rnvimr_enable_ex"] = 1
          -- Quit ranger popup after opening a file
          vim.g["rnvimr_enable_picker"] = 1

          -- Wipe the buffers corresponding to files deleted in ranger
          vim.g["rnvimr_enable_bw"] = 1
        '';
    }
  ];
}
