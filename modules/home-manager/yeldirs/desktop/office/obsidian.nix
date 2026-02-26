{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.desktop.office.obsidian;
in
{
  options = {
    yeldirs.desktop.office.obsidian.enable = lib.mkEnableOption "obsidian";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.unstable; [
      obsidian
    ];

    home.persistence."/persist" = {
      directories = [
        ".config/obsidian"
      ];
    };

    xdg.desktopEntries = {
      obsidian = {
        name = "Obsidian";
        type = "Application";
        exec = "${lib.getExe pkgs.obsidian} --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %u";
        icon = "obsidian";
        categories = [ "Office" ];
        mimeType = [ "x-scheme-handler/obsidian" ];
      };
    };
  };
}
