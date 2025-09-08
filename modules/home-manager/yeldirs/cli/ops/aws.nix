{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.ops.aws;
in
{
  options = {
    yeldirs.cli.ops.aws = {
      enable = lib.mkEnableOption "aws";
      region = lib.mkOption {
        type = lib.types.string;
        default = "eu-central-1";
      };

      ecrIntegration = lib.mkEnableOption "docker integration for ecr";
      ssmTools = lib.mkEnableOption "aws-ssm-tools";
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

      file = lib.mkIf cfg.ecrIntegration {
        ".docker/config.json".text = "{\"credsStore\":\"ecr-login\"}";
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
