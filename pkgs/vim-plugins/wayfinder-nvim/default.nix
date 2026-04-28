{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "wayfinder-nvim";
  version = "v0.1.6";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "error311";
    repo = "wayfinder.nvim";
    rev = version;
    sha256 = "sha256-nOfs0wwKH87XBMlBdhSsHk1atV8Ljg1aMgSVO8zfyC8=";
  };
  meta.homepage = "https://github.com/error311/wayfinder.nvim";
}
