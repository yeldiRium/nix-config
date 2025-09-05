{
  stdenv,
  bash,
  fetchFromGitHub,
}: let
  version = "v0.2.6";
in
  stdenv.mkDerivation {
    name = "konfig";
    version = version;

    src = fetchFromGitHub {
      owner = "corneliusweig";
      repo = "konfig";
      rev = version;
      hash = "sha256-qcYDiQJqXEWrGEwVdiB7922M8xT9mcbMdMBst5STOJk=";
    };
    system = stdenv.hostPlatform.system;

    buildInputs = [bash];

    installPhase =
      /*
      bash
      */
      ''
        mkdir -p "$out/bin"
        cp "konfig" "$out/bin/konfig"
      '';
  }
