{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "xpdig";
  version = "v1.22.0";
  src = fetchFromGitHub {
    owner = "brunoluiz";
    repo = "xpdig";
    rev = version;
    hash = "sha256-baNtG/C/inFOAWIYzxns3EBkf885ISyjz+UhOMB2VZA=";
  };

  vendorHash = "sha256-T0dlZYq4UOCO8+PYugM5S5jtJGl6gup67KF3+rQMhGc=";

  meta = {
    description = "🧰 Dig into Crossplane traces via TUI (a là k9s)";
    homepage = "https://github.com/brunoluiz/xpdig";
    license = lib.licenses.asl20;
    mainProgram = "xpdig";
  };
}
