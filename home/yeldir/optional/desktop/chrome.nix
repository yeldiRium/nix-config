{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    google-chrome
  ];

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".config/google-chrome"
    ];
  };

  xdg.desktopEntries = {
    google-chrome = {
      name = "Google Chrome";
      genericName = "Web Browser";
      type = "Application";
      exec = "${lib.getExe pkgs.google-chrome} --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto %U";
      icon = "google-chrome";
      categories = ["Network" "WebBrowser"];
      mimeType = ["application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https"];
      terminal = false;
      startupNotify = true;
    };
  };
}
