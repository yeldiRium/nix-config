{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.hetzner;
in
{
  options = {
    yeldirs.cli.ops.hetzner = {
      enable = lib.mkEnableOption "hetzner";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hcloud
    ];
    programs = {
      zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        eval "$(${lib.getExe pkgs.hcloud} completion zsh)"
      '';
    };
    sops.secrets.hetznerConfig = {
      path = "${config.home.homeDirectory}/.config/hcloud/cli.toml";
    };
  };
}
