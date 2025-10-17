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
      echo ${gotestsum}
      ${lib.getExe gotestsum} ./...
    '';

  vendorHash = "sha256-9dguTsRa0PvgydQzPWRIcjtJdgFbsXnWkIiAI8LKSuM=";
}
