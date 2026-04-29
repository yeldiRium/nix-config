{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "wayfinder-nvim";
  version = "v0.1.7";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "error311";
    repo = "wayfinder.nvim";
    rev = version;
    sha256 = "sha256-8JJmGF5dQ5zil/h1/xzCp8JxZUqKuw0fHEPOfh6duks=";
  };
  meta.homepage = "https://github.com/error311/wayfinder.nvim";
}
