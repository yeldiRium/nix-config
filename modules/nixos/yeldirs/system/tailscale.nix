{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.yeldirs.system.tailscale;
in {
  options = {
    yeldirs.system.tailscale = {
      enable = lib.mkEnableOption "tailscale";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.system.sops.enable;
        message = "sops must be enabled for tailscale autoconfig to work";
      }
    ];

    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
      authKeyFile = config.sops.secrets.tailscale-authkey.path;
    };

    sops.secrets.tailscale-authkey = {};
  };
}
