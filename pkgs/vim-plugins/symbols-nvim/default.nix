{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "symbols-nvim";
  version = "v0.4.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "oskarrrrrrr";
    repo = "symbols.nvim";
    rev = version;
    sha256 = "sha256-cGgPFPWdzAl5ETHCZ8OBnJocEcWuT14ksuYvK30Oh9M=";
  };
  meta.homepage = "https://github.com/oskarrrrrrr/symbols.nvim";
}
