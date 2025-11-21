{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.tofu;
in
{
  options = {
    yeldirs.cli.ops.tofu = {
      enable = lib.mkEnableOption "tofu ops tools";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      opentofu
    ];

    yeldirs.cli.essentials.neovim.supportedLanguages = [
      "tofu"
    ];
  };
}
