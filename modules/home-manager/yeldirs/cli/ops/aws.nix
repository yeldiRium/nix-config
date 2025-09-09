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

      ecrIntegration = lib.mkEnableOption "docker integration for ecr";
      ssmTools = lib.mkEnableOption "aws-ssm-tools";

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
          default = {};
          type = attrsOf (submodule {
            options = {
              accountId = lib.mkOption { type = str; };
              roleName = lib.mkOption { type = str; };
              startUrl = lib.mkOption { type = str; };
              registrationScopes = lib.mkOption { type = str; };
            };
          });
        };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        with pkgs;
        [
          awscli2
        ]
        ++ lib.optionals cfg.ecrIntegration [
          amazon-ecr-credential-helper
        ]
        ++ lib.optionals cfg.ssmTools [
          ssm-session-manager-plugin
          (
            with python312Packages;
            buildPythonPackage {
              name = "aws-ssm-tools";
              version = "1.6.0";
              src = fetchFromGitHub {
                owner = "mludvig";
                repo = "aws-ssm-tools";
                rev = "800657551361bf5e191513d1409d0f6155add091";
                hash = "sha256-rCW+ebgHN4THHVZAMkozNkYlcqUdD3xn/mqPaQBIPOg=";
              };
              propagatedBuildInputs = [
                pexpect
                packaging
                botocore
                boto3
              ];
            }
          )
        ];

      sessionVariables = {
        AWS_REGION = cfg.region;
      };

      file = {
        ".docker/config.json" = {
          enable = cfg.ecrIntegration;
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
              ''
            ) cfg.ssoConfigs;
            ssoConfigLines = lib.concatLines ssoConfigSections;
          in
          {
            text = # toml
            ''
              [default]
              region=${cfg.region}
              output=${defaultOutput}
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
