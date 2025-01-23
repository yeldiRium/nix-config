{
  imports = [
    ../../shared/common/global
    ../../shared/darwin/global

    ../../shared/darwin/users/yeldir
  ];

  nix.extraOptions = ''
    auto-optimise-store = false
    experimental-features = nix-command flakes
  '';

  programs = {
    zsh.enable = true;
  };

  services = {
    nix-daemon.enable = true;
  };

  networking = {
    computerName = "rekorder";
    hostName = "rekorder";
  };

  system.stateVersion = 5;
}
