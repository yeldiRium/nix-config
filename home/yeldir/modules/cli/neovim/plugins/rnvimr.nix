{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.cli.neovim.nrvimr;
in {
  options = {
    yeldirs.cli.neovim.nrvimr.enable = lib.mkEnableOption "neovim plugin nrvimr";
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.neovim.enable;
        message = "neovim must be enabled for the plugin nrvimr to work";
      }
    ];

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
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
  };
}
