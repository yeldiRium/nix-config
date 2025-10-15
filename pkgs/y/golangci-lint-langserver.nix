{
  buildGoModule,
  fetchFromGitHub,
  golangci-lint,
  writableTmpDirAsHomeHook,
  lib,
}:
buildGoModule rec {
  pname = "golangci-lint-langserver";
  version = "d1d98ad260f3943a60c3930c3f539e326cb974db";
  src = fetchFromGitHub {
    owner = "yeldiRium";
    repo = "golangci-lint-langserver";
    rev = version;
    hash = "sha256-z9Q2ws6l2X1alF23is90PEoBCbtqkhVwDclyMnEAoUk=";
  };

  vendorHash = "sha256-kbGTORTTxfftdU8ffsfh53nT7wZldOnBZ/1WWzN89Uc=";

  nativeCheckInputs = [
    golangci-lint
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Language server for golangci-lint";
    homepage = "https://github.com/nametake/golangci-lint-langserver";
    license = lib.licenses.mit;
    mainProgram = "golangci-lint-langserver";
  };
}
