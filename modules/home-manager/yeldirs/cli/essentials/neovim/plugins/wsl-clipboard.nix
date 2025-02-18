{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.neovim.wsl-clipboard;
in {
  options = {
    yeldirs.cli.essentials.neovim.wsl-clipboard.enable = lib.mkEnableOption "neovim plugin wsl-clipboard";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.neovim.enable;
        message = "neovim must be enabled for the plugin wsl-clipboard to work";
      }
    ];

    programs.neovim.extraLuaConfig =
      /*
      lua
      */
      ''
        vim.g.clipboard = {
          name = "wsl-clipboard",
          copy = {
            ["+"] = {"clip.exe"},
            ["*"] = {"clip.exe"},
          },
          paste = {
            ["+"] = {"powershell.exe", "-c", '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'},
            ["*"] = {"powershell.exe", "-c", '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'},
          },
          cache_enabled = true,
        }
      '';
  };
}
