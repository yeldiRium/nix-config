{
  lib,
  shellcheck,
  stdenv,
}:
stdenv.mkDerivation {
  name = "k8s-scripts";
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

  meta = {
    description = "A collection of helper scripts for k8s written in bash.";
    license = lib.licenses.mit;
  };
}
