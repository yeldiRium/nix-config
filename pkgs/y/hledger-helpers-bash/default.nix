{
  lib,
  shellcheck,
  stdenv,
}:
stdenv.mkDerivation {
  name = "hledger-helpers-bash";
  src = ./.;

  checkInputs = [
    shellcheck
  ];
  checkPhase = # bash
    ''
      ${lib.getExe shellcheck} ./src/*
    '';
  doCheck = true;

  installPhase = # bash
    ''
      mkdir -p $out/bin

      cp ./src/* $out/bin
    '';
}
