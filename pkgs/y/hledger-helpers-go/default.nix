{
  buildGoModule,
  gotestsum,
  hledger,
  lib,
}:
buildGoModule {
  name = "hledger-helpers-go";
  src = builtins.path {
    path = ./.;
  };

  checkInputs = [
    gotestsum
  ];
  checkPhase = # bash
    ''
      ${lib.getExe gotestsum}
    '';

  runtimeInputs = [
    hledger
  ];

  vendorHash = "sha256-OvJH4U6vBMB5s4xuLsOBNkpcZxN3UmURQZJLPDVU9+o=";

  meta = {
    description = "A collection of helper scripts for hledger written in go.";
    license = lib.licenses.mit;
  };
}
