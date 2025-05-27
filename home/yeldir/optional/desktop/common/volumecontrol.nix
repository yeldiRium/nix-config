{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    pwvucontrol
  ];

  xdg.desktopEntries = {
    "com.saivert.pwvucontrol" = {
      name = "pwvucontrol";
      type = "Application";
      exec = "env GSK_RENDERER=ngl ${lib.getExe pkgs.pwvucontrol}";
      icon = "com.saivert.pwvucontrol";
      categories = ["Audio" "System"];
      terminal = false;
      startupNotify = true;
    };
  };
}
