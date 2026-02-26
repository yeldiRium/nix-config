{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
in
{
  imports = [
    ./chrome.nix
    ./firefox.nix
  ];

  config = lib.mkIf desktopCfg.enable {
    home.packages = with pkgs; [
      speedcrunch
    ];

    programs = {
      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = config.programs.zsh.enable;
      };
    };
  };
}
