{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.office.citrix;
in
{
  options = {
    yeldirs.desktop.office.citrix.enable = lib.mkEnableOption "citrix";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pinned-citrix.citrix_workspace
    ];

    # home.persistence = {
    #   "/persist/${config.home.homeDirectory}" = {
    #     directories = [
    #       ".citrix"
    #       "citrix"
    #     ];
    #   };
    # };
  };
}
