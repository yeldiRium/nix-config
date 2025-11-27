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

    programs = {
      zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        complete -o nospace -C "${lib.getExe pkgs.opentofu}" tofu
      '';
    };
    yeldirs.cli.essentials.neovim.supportedLanguages = [
      "tofu"
    ];
  };
}
