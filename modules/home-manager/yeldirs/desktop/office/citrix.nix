{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktopCfg = config.yeldirs.desktop;
  cfg = config.yeldirs.desktop.office.citrix;
in
{
  options = {
    yeldirs.desktop.office.citrix.enable = lib.mkEnableOption "citrix";
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      pinned-citrix.citrix_workspace
    ];

    # home.persistence = {
    #   "/persist" = {
    #     directories = [
    #       ".citrix"
    #       "citrix"
    #     ];
    #   };
    # };
  };
}
