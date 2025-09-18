{
  fetchFromGitHub,
  python3Packages,
}:
(
  with python3Packages;
  buildPythonPackage rec {
    name = "aws-ssm-tools";
    version = "2.0.1";
    pyproject = true;
    src = fetchFromGitHub {
      owner = "mludvig";
      repo = "aws-ssm-tools";
      rev = "v${version}";
      hash = "sha256-Pv4s0wnjrRKxdJxtQSIL+uTpkup2Civ2e9m6Dv/t2eM=";
    };
    build-system = [
      hatchling
    ];
    dependencies = [
      pexpect
      packaging
      tabulate
      simple-term-menu
      botocore
      boto3
    ];
  }
)
