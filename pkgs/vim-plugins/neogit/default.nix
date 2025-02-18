{
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin {
  pname = "neogit";
  version = "2025-01-21";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "NeogitOrg";
    repo = "neogit";
    rev = "63124cf520ff24d09deb3b850e053908ab0fc66a";
    sha256 = "sha256-mg3wvNgKUlPqQ2FIIAD3XLhUWq09NQ1m88q46XKivOI=";
  };
  meta.homepage = "https://github.com/NeogitOrg/neogit";
}
