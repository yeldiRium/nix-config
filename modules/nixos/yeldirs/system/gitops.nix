{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.yeldirs.system.gitops;
in
{
  imports = [
    inputs.comin.nixosModules.comin
  ];

  options = {
    yeldirs.system.gitops = {
      enable = lib.mkEnableOption "gitops";
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
    };

    sops.secrets.configPullToken = { };
  };
}
