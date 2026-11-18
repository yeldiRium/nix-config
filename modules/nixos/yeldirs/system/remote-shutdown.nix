{
  config,
  lib,
  pkgs,
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
              command = "${pkgs.systemd}/bin/poweroff";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}
