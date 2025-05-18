{
  fetchFromGitHub,
  pkgs,
}:
pkgs.unstable.tmuxPlugins.mkTmuxPlugin {
  pluginName = "vim-tmux-navigator";
  rtpFilePath = "vim-tmux-navigator.tmux";
  version = "unstable-2025-02-25";
  src = fetchFromGitHub {
    owner = "christoomey";
    repo = "vim-tmux-navigator";
    rev = "791dacfcfc8ccb7f6eb1c853050883b03e5a22fe";
    hash = "sha256-8KAKHK5pOB9yguhpt0WdtIPezHwl0yMUK205JkpbPOg=";
  };
}
