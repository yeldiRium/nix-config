{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "fold-cycle-nvim";
  version = "2024-06-19";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "jghauser";
    repo = "fold-cycle.nvim";
    rev = "20e9b468b771ebf33b6806a0e872eee53c5a20c9";
    sha256 = "sha256-vlRKOX51X41DF3zljOtn80DpAzy9J3GMMbLaP5ApjKk=";
  };
  meta.homepage = "https://github.com/jghauser/fold-cycle.nvim";
}
