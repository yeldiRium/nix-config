{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs.unstable; [
    obsidian
  ];

  home.persistence."/persist/${config.home.homeDirectory}" = {
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
}
