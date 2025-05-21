{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "screenkey-nvim";
  version = "2024-12-09";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "NStefan002";
    repo = "screenkey.nvim";
    rev = "16390931d847b1d5d77098daccac4e55654ac9e2";
    sha256 = "sha256-EGyIkWcQbCurkBbeHpXvQAKRTovUiNx1xqtXmQba8Gg=";
  };
  meta.homepage = "https://github.com/NStefan002/screenkey.nvim";
}
