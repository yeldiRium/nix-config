{
  fetchFromGitHub,
  python3Packages,
}:
(
  with python3Packages;
  buildPythonPackage rec {
    name = "aws-ssm-tools";
    version = "2.2.1";
    pyproject = true;
    src = fetchFromGitHub {
      owner = "mludvig";
      repo = "aws-ssm-tools";
      rev = "v${version}";
      hash = "sha256-RrbJ6s75DNX2bSGzHyRlEspdJl8g9eTjeCaoHxNXOCY=";
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
