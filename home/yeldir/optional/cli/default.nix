{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./gh.nix
    ./git.nix
    ./gpg.nix
    ./ranger.nix
    ./ssh.nix
    ./thefuck.nix
  ];

  # TODO:
  # - add hstr package

  home.packages = with pkgs; [
    # poweruser
    jq
    silver-searcher
    btop
    zip
    unzip

    # nix utils
    alejandra

    # development
    devbox
  ];

  home.shellAliases = {
    ll = "ls -al";
  };
}
