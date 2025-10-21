{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.aws;

  defaultOutput = "json";
in
{
  options = {
    yeldirs.cli.ops.aws = {
      enable = lib.mkEnableOption "aws";
      region = lib.mkOption {
        type = lib.types.str;
        default = "eu-central-1";
      };
      ssoConfigs =
        with lib.types;
        lib.mkOption {
          description = "A set of sso configs that are used to log in to aws.";
          example = {
            cool-profile = {
              accountId = "012345678910";
              roleName = "MyAwsRole";
              startUrl = "https://my-sso-provider.com/start";
              registrationScopes = "sso:account:access";
            };
          };
          default = { };
          type = attrsOf (submodule {
            options = {
              accountId = lib.mkOption { type = str; };
              roleName = lib.mkOption { type = str; };
              startUrl = lib.mkOption { type = str; };
              registrationScopes = lib.mkOption { type = str; };
            };
          });
        };

      ec2 = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "ec2 support";
          default = cfg.enable;
        };
      };
      ecr = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "ecr support";
          default = cfg.enable;
        };
        enableDockerIntegration = lib.mkOption {
          type = lib.types.bool;
          description = "docker integration for ecr login";
          default = cfg.ecr.enable;
        };
      };
      ecs = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "ecs support";
          default = cfg.enable;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        with pkgs;
        [
          awscli2
          (y.shellScript ./aws-scripts/aws-sg-why)
        ]
        ++ lib.optionals cfg.ecr.enable [
          amazon-ecr-credential-helper
        ]
        ++ lib.optionals (cfg.ec2.enable || cfg.ecs.enable) [
          ssm-session-manager-plugin
          y.aws-ssm-tools
        ];

      sessionVariables = {
        AWS_REGION = cfg.region;
      };

      file = {
        ".docker/config.json" = {
          enable = cfg.ecr.enableDockerIntegration;
          text = "{\"credsStore\":\"ecr-login\"}";
        };
        ".aws/config" =
          let
            ssoConfigSections = lib.mapAttrsToList (
              profileName: profileConfig: # toml
              ''
                [profile ${profileName}]
                sso_session = ${profileName}
                sso_account_id = ${profileConfig.accountId}
                sso_role_name = ${profileConfig.roleName}
                region = ${cfg.region}
                output = ${defaultOutput}
                [sso-session ${profileName}]
                sso_start_url = ${profileConfig.startUrl}
                sso_region = ${cfg.region}
                sso_registration_scopes = ${profileConfig.registrationScopes}
              '') cfg.ssoConfigs;
            ssoConfigLines = lib.concatLines ssoConfigSections;
          in
          {
            text = # toml
            ''
              [default]
              region=${cfg.region}
              output=${defaultOutput}
              cli_pager=bat --paging=never
            ''
            + ssoConfigLines;
          };
      };
    };

    programs = {
      zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        complete -C aws_completer aws
      '';
    };

    home.persistence = {
      "/persist/${config.home.homeDirectory}" = {
        directories = [
          ".aws"
        ];
      };
    };
  };
}
