{
  config,
  lib,
  ...
}:
let
  cfg = config.yeldirs.system.networking;
in
{
  options = {
    yeldirs.system.networking = {
      enableNetworkManager = lib.mkEnableOption "networkmanager";
    };
  };

  config = lib.mkIf cfg.enableNetworkManager {
    networking = {
      networkmanager = {
        enable = true;
      };
    };

    programs.nm-applet.enable = true;

    environment.persistence = {
      "/persist/system" = {
        directories = [
          "/etc/NetworkManager/system-connections"
        ];
      };
    };
  };
}
