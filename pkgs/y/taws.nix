{ fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "taws";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "huseyinbabal";
    repo = "taws";
    tag = "v${version}";
    hash = "sha256-Ndqumxm14Dq5FAD31bj5WOITCLC9gy+LAKpAngaQj10=";
  };

  cargoHash = "sha256-l7P+3H9gaFyKt4d0t+IA8ELMOfmaBkb7BK3FYmC3LbQ=";

  meta = {
    mainProgram = "taws";
    homepage = "https://github.com/huseyinbabal/taws";
  };
}
