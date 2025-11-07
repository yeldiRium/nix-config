{
  buildGoModule,
  gotestsum,
  lib,
}:
buildGoModule {
  name = "git-find-remote";
  src = builtins.path {
    path = ./.;
  };

  checkInputs = [
    gotestsum
  ];
  checkPhase = # bash
    ''
      ${lib.getExe gotestsum} ./...
    '';

  vendorHash = "sha256-Zxntgt3UtTTf0fq+/KfEmhRYi9UxJmkp8WvRbrEPJYo=";

  meta = {
    mainProgram = "git-find-remote";
  };
}
