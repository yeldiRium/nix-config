{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.essentials;
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        y.ijq
        jq
      ];

      shellAliases = {
        copylastijq = "cat \${XDG_DATA_HOME}/ijq/history | tail -n 1 | clipc";
      };
    };

    xdg.configFile = {
      "ijq/config".text = # scfg
        ''
          hide-input-pane true
        '';
    };
  };
}
