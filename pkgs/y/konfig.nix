{
  stdenv,
  bash,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "konfig";
  version = "unstable-2025-09-18";

  src = fetchFromGitHub {
    owner = "yeldirium";
    repo = "konfig";
    rev = "df45417893b8d54fc02c7c8821cb3b5024b28bbf";
    hash = "sha256-rUWnyrEJChjc3G5d3UwETgS2Qo2wUAfsWFQsfQ5xA4U=";
  };
  system = stdenv.hostPlatform.system;

  buildInputs = [ bash ];

  installPhase =
    # bash
    ''
      mkdir -p "$out/bin"
      cp "konfig" "$out/bin/konfig"
    '';
}
