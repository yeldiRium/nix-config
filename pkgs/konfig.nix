{
  stdenv,
  bash,
  fetchFromGitHub,
}: stdenv.mkDerivation {
    name = "konfig";

    src = fetchFromGitHub {
      owner = "yeldirium";
      repo = "konfig";
      rev =  "2bb3950cbaa266162119b30b3b3a1a8a85dc97af";
      hash = "sha256-WT9bVTzuFuS6EOREKXEkyIbmhrqKlm5M6J3KRU1fUko=";
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
