{pkgs, ...}: {
  imports = [
    ./gh.nix
  ];

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
