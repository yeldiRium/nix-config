{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./gh.nix
    ./git.nix
    ./gpg.nix
    ./kitty.nix
    ./nvim.nix
    ./ranger.nix
    ./ssh.nix
    ./thefuck.nix
    ./zsh.nix
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
  ];

  home.shellAliases = {
    ll = "ls -al";
  };
}
