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
      echo ${gotestsum}
      ${lib.getExe gotestsum} ./...
    '';

  vendorHash = "sha256-9dguTsRa0PvgydQzPWRIcjtJdgFbsXnWkIiAI8LKSuM=";

  meta = {
    mainProgram = "git-find-default-branch";
  };
}
