{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.fluxcd;
in
{
  options = {
    yeldirs.cli.ops.fluxcd = {
      enable = lib.mkEnableOption "fluxcd";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fluxcd
    ];

    programs = {
      zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        source <(${lib.getExe pkgs.fluxcd} completion zsh)
      '';
    };
  };
}
