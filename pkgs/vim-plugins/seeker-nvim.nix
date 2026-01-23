{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "seeker-nvim";
  version = "1.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "2kabhishek";
    repo = "seeker.nvim";
    rev = version;
    sha256 = "sha256-6G2hLpwhinni8Bzobk3Ktx5QiY6/XRmGGIIYhaqWoeE=";
  };
  meta.homepage = "https://github.com/2kabhishek/seeker.nvim";
}
