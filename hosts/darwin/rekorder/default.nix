{
  imports = [
    ../../shared/global
    ../shared/global

    ../shared/users/yeldir
  ];

  nix.extraOptions = ''
    auto-optimise-store = false
    experimental-features = nix-command flakes pipe-operators
  '';

  programs = {
    zsh.enable = true;
  };

  networking = {
    computerName = "rekorder";
    hostName = "rekorder";
  };

  yeldirs = {
    system = {
      sops = {
        enable = true;
        keyFile = "/Users/yeldir/querbeet/keys.txt";
      };
    };
  };

  system = {
    startup.chime = false;
    stateVersion = 5;
  };
}
