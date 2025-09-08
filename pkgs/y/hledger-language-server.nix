{
  pkgs,
  lib,
}: let
  revision = "70f93977b7c2baa5c8eb281c4eb75ac744f9cb0a";
in
  pkgs.unstable.buildGo123Module {
    name = "hledger-language-server";
    pname = "hledger-language-server";
    version = revision;
    src = pkgs.fetchFromGitHub {
      owner = "yeldiRium";
      repo = "hledger-language-server";
      rev = revision;
      hash = "sha256-LpTrUaHC+P64+Ske8UR7zG6U7F2cWXKb940rK4SAMfA=";
    };

    vendorHash = "sha256-MskYchNvyehWQDLX/T8PwOo6k+6KKFlZW2aoE6BIFTc=";

    meta = {
      mainProgram = "hledger-language-server";
      description = "Language server for hledger";
      homepage = "https://github.com/yeldiRium/hledger-language-server";
      license = lib.licenses.mit;
    };
  }
