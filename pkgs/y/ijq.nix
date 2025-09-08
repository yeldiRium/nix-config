{ pkgs, ... }:
(pkgs.buildGoModule {
  pname = "ijq";
  version = "0.4.0-yel.1";
  src = pkgs.fetchFromGitHub {
    owner = "yeldiRium";
    repo = "ijq";
    rev = "07373230918b51388c49b43e76fd1a7e9975deeb";
    hash = "sha256-pQzuhADWJDFap8LsY75Uosu+8NV9WhYRL982sO445Rc=";
  };
  vendorHash = "sha256-1R3rv3FraT53dqGECRr+ulhplmmByqRW+VJ+y6nFR+Y=";
})
