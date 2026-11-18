{
  config,
  lib,
  ...
}:
let
  cfg = config.yeldirs.system.remote-shutdown;
in
{
  options = {
    yeldirs.system.remote-shutdown = {
      enable = lib.mkEnableOption "remote shutdown";
    };
  };

  config = lib.mkIf cfg.enable {
    security.sudo = {
      extraRules = [
        {
          groups = [ "wheel" ];
          commands = [
            {
              command = "/run/current-system/sw/bin/poweroff";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/reboot";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}
