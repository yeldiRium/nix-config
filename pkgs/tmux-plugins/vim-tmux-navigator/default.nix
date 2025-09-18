{
  fetchFromGitHub,
  pkgs,
}:
pkgs.unstable.tmuxPlugins.mkTmuxPlugin {
  pluginName = "vim-tmux-navigator";
  rtpFilePath = "vim-tmux-navigator.tmux";
  version = "unstable-2025-07-15";
  src = fetchFromGitHub {
    owner = "christoomey";
    repo = "vim-tmux-navigator";
    rev = "c45243dc1f32ac6bcf6068e5300f3b2b237e576a";
    hash = "sha256-IEPnr/GdsAnHzdTjFnXCuMyoNLm3/Jz4cBAM0AJBrj8=";
  };
}
