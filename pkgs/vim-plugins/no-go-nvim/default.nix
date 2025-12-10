{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "no-go-nvim";
  version = "v0.2.1";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "TheNoeTrevino";
    repo = "no-go.nvim";
    rev = version;
    sha256 = "sha256-uADB7BIB2ocwcPgjhGOfpTiW5waKJS17qzWiIg8qppM=";
  };
  meta.homepage = "https://github.com/TheNoeTrevino/no-go.nvim";
}
