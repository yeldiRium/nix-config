{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.desktop.essentials.firefox;
in {
  options = {
    yeldirs.desktop.essentials.firefox = {
      enable = lib.mkEnableOption "firefox";
      default = lib.mkOption {
        description = "default browser";
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [
            pkgs.tridactyl-native
          ];
        };
      };
    };

    xdg.mimeApps.defaultApplications = lib.mkIf cfg.default {
      "application/pdf" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "application/xhtml_xml" = "firefox.desktop";
      "text/html" = "firefox.desktop";
    };

    xdg.desktopEntries = {
      firefox = {
        name = "Firefox";
        genericName = "Web Browser";
        type = "Application";
        exec = "${lib.getExe pkgs.firefox} --name firefox %U";
        actions = {
          "new-private-window" = {
            exec = "${lib.getExe pkgs.firefox} --private-window %U";
          };
          "new-window" = {
            exec = "${lib.getExe pkgs.firefox} --new-window %U";
          };
          "profile-manager-window" = {
            exec = "${lib.getExe pkgs.firefox} --ProfileManager %U";
          };
        };
        icon = "firefox";
        categories = ["Network" "WebBrowser"];
        mimeType = [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/vnd.mozilla.xul+xml"
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
        settings = {
          StartupWMClass = "firefox";
          Version = "1.4";
        };
      };
    };

    home = {
      persistence."/persist/${config.home.homeDirectory}" = {
        directories = [
          ".mozilla"
        ];
      };
    };
  };
}
