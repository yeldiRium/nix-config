{
  imports = [
    ../../shared/global
    ../shared/global

    ../shared/users/yeldir
  ];

  nix.extraOptions = ''
    auto-optimise-store = false
    experimental-features = nix-command flakes
  '';

  programs = {
    zsh.enable = true;
  };

  networking = {
    computerName = "rekorder";
    hostName = "rekorder";
  };

  system.stateVersion = 5;
}
