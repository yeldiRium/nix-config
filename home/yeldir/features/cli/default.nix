{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./git.nix
    ./gpg.nix
    ./kitty.nix
    ./nvim.nix
    ./ranger.nix
    ./ssh.nix
    ./zsh.nix
  ];

  # TODO:
  # - add hstr package
  # - add gh package

  home.packages = with pkgs; [
    # poweruser
    jq
    silver-searcher

    # nix utils
    alejandra
  ];
}
