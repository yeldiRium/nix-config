{ pkgs, ... }:
(pkgs.buildGoModule rec {
  pname = "ijq";
  version = "e6b32fe04c6b8dbe5cd29bad13d6a29984881596";
  src = pkgs.fetchFromGitHub {
    owner = "gpanders";
    repo = "ijq";
    rev = version;
    hash = "sha256-qqiSUvM7sAaWq1pVp2dSNuh6x4rCSExikcBjZ6N2ZPI=";
  };
  vendorHash = "sha256-aU/0CIbI49OwgY6ioT50uPxld/rHAve3+KoILgPpWSQ=";
})
