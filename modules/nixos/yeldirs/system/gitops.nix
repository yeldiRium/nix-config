{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.yeldirs.system.gitops;

  cominPort = 4243;
in
{
  imports = [
    inputs.comin.nixosModules.comin
  ];

  options = {
    yeldirs.system.gitops = {
      enable = lib.mkEnableOption "gitops";

      openFirewallForInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          To scrape comin metrics, open firewall on these interfaces.
          Look up the docker bridge interface on which alloy is deployed.
          The interface name is always `br-` followed by the first twelve
          characters in the network's id.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.yeldirs.system.sops.enable;
        message = "sops must be enabled for gitops to work";
      }
    ];

    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/yeldiRium/nix-config.git";
          branches.main.name = "main";
          auth.access_token_path = config.sops.secrets.configPullToken.path;
        }
      ];

      exporter = {
        port = cominPort;
      };
    };

    sops.secrets.configPullToken = { };

    networking.firewall.interfaces = lib.genAttrs cfg.openFirewallForInterfaces (_: {
      allowedTCPPorts = [ cominPort ];
    });
  };
}
