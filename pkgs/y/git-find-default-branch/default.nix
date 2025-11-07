{
  buildGoModule,
  gotestsum,
  lib,
}:
buildGoModule {
  name = "git-find-default-branch";
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

  vendorHash = "sha256-UNsQgTKdyvnUYiF8Mfi7GkwfMEX9eQIUhPNMmELiTwI=";

  meta = {
    mainProgram = "git-find-default-branch";
  };
}
