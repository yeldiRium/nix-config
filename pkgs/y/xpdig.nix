{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "xpdig";
  version = "v1.25.0";
  src = fetchFromGitHub {
    owner = "brunoluiz";
    repo = "xpdig";
    rev = version;
    hash = "sha256-K9UJjaZVuzdT+7Aog3thlVW3xp/jNvqaQByT7mk4J58=";
  };

  vendorHash = "sha256-YPNrIJjNuItvxTRzmjh3CuMmRzzzzLhz07nhy11drcU=";

  meta = {
    description = "🧰 Dig into Crossplane traces via TUI (a là k9s)";
    homepage = "https://github.com/brunoluiz/xpdig";
    license = lib.licenses.asl20;
    mainProgram = "xpdig";
  };
}
