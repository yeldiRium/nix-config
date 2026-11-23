{
  buildGo126Module,
  fetchFromGitHub,
  lib,
}:
buildGo126Module rec {
  pname = "xpdig";
  version = "v1.26.0";
  src = fetchFromGitHub {
    owner = "brunoluiz";
    repo = "xpdig";
    rev = version;
    hash = "sha256-z02p+0Mu6jmPjHDDF/mYEsYzVA9cx4Rsx4ARmT4Kwt4=";
  };

  vendorHash = "sha256-rwQOOIDWKwZThFUhOM2OifeSr696ei7Kz8Yla7QeazM=";

  meta = {
    description = "🧰 Dig into Crossplane traces via TUI (a là k9s)";
    homepage = "https://github.com/brunoluiz/xpdig";
    license = lib.licenses.asl20;
    mainProgram = "xpdig";
  };
}
