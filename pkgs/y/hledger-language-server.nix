{
  pkgs,
  lib,
}:
let
  revision = "v0.2.0";
in
pkgs.buildGo124Module {
  name = "hledger-language-server";
  pname = "hledger-language-server";
  version = revision;
  src = pkgs.fetchFromGitHub {
    owner = "yeldiRium";
    repo = "hledger-language-server";
    rev = revision;
    hash = "sha256-/eUBTpcsF+/efVa4Nuqj9gaI9tvVJA+KiufjNHD8TVU=";
  };

  vendorHash = "sha256-3clCH55J3ImjwSMkepqGJwwPfOIUXDrqlA8dXQeSa6s=";

  meta = {
    mainProgram = "hledger-language-server";
    description = "Language server for hledger";
    homepage = "https://github.com/yeldiRium/hledger-language-server";
    license = lib.licenses.mit;
  };
}
