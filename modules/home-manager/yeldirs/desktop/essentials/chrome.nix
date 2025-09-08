{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.yeldirs.desktop.essentials.chrome;
in
{
  options = {
    yeldirs.desktop.essentials.chrome = {
      enable = lib.mkEnableOption "chrome";
      default = lib.mkOption {
        description = "default browser";
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      google-chrome
    ];

    home.persistence."/persist/${config.home.homeDirectory}" = {
      directories = [
        ".config/google-chrome"
      ];
    };

    xdg.mimeApps = lib.mkIf cfg.default (lib.y.webbrowser.xdgMimeApps "google-chrome.desktop");

    xdg.desktopEntries = {
      google-chrome = {
        name = "Google Chrome";
        genericName = "Web Browser";
        type = "Application";
        exec = "${lib.getExe pkgs.google-chrome} --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %U";
        icon = "google-chrome";
        categories = [
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
        terminal = false;
        startupNotify = true;
      };
    };
  };
}
