{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.nrvimr;
in {
  options = {
    yeldirs.cli.essentials.neovim.nrvimr.enable = lib.mkEnableOption "neovim plugin nrvimr";
  };
  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = rnvimr;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            vim.keymap.set("n", "<leader>fr", ":RnvimrToggle<cr>", { desc = "Toggle ranger file browser" })

            -- Replace netrw
            vim.g["rnvimr_enable_ex"] = 1
            -- Quit ranger popup after opening a file
            vim.g["rnvimr_enable_picker"] = 1

            -- Wipe the buffers corresponding to files deleted in ranger
            vim.g["rnvimr_enable_bw"] = 1
          '';
      }
    ];
  };
}
