{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "nvim-early-retirement";
  version = "2024-08-17";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "chrisgrieser";
    repo = "nvim-early-retirement";
    rev = "2c36a5671b9d8f0d9e11b77c5a55de802bc45e34";
    sha256 = "sha256-+W3AG99nzgr36t9Sg192hb/MH8s0uGAPD0cLBnil+og=";
  };
  meta.homepage = "https://github.com/chrisgrieser/nvim-early-retirement";
}
