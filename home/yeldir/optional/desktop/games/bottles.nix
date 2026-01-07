{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    bottles
  ];

  xdg.desktopEntries = {
    "com.usebottles.bottles" = {
      name = "Bottles";
      type = "Application";
      exec = "env GSK_RENDERER=ngl ${lib.getExe pkgs.bottles} %u";
      icon = "com.usebottles.bottles";
      categories = [
        "Utility"
        "GNOME"
        "GTK"
      ];
      mimeType = [
        "x-scheme-handler/bottles"
        "application/x-ms-dos-executable"
        "application/x-msi"
        "application/x-ms-shortcut"
        "application/x-wine-extension-msp"
      ];
      terminal = false;
      startupNotify = true;
    };
  };

  home.persistence = {
    "/persist" = {
      directories = [
        ".local/share/bottles"
      ];
    };
  };
}
