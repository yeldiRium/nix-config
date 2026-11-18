{
  lib,
  pkgs,
  ...
}:
{
  options = {
    yeldirs.system.quiet-boot = {
      enable = lib.mkEnableOption "quiet boot";
    };
  };
  config = {
    boot = {
      plymouth = {
        enable = true;
        theme = "blahaj";
        themePackages = with pkgs; [
          plymouth-blahaj-theme
        ];
      };
      loader.timeout = 0;
      kernelParams = [
        "quiet"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      consoleLogLevel = 3;
      initrd.verbose = false;
    };
  };
}
