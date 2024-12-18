{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nautilus
  ];

  xdg.desktopEntries = {
    "org.gnome.Nautilus" = {
      name = "Files";
      type = "Application";
      exec = "env GSK_RENDERER=ngl ${lib.getExe pkgs.nautilus} --new-window %U";
      icon = "org.gnome.Nautilus";
      categories = ["GNOME" "GTK" "Utility" "Core" "FileManager"];
      mimeType = ["inode/directory" "application/x-7z-compressed" "application/x-7z-compressed-tar" "application/x-bzip" "application/x-bzip-compressed-tar" "application/x-compress" "application/x-compressed-tar" "application/x-cpio" "application/x-gzip" "application/x-lha" "application/x-lzip" "application/x-lzip-compressed-tar" "application/x-lzma" "application/x-lzma-compressed-tar" "application/x-tar" "application/x-tarz" "application/x-xar" "application/x-xz" "application/x-xz-compressed-tar" "application/zip" "application/gzip" "application/bzip2" "application/x-bzip2-compressed-tar" "application/vnd.rar" "application/zstd" "application/x-zstd-compressed-tar"];
      terminal = false;
      startupNotify = true;
    };
  };
}
