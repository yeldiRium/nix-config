{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  username = "yeldir";
in {
  imports = [
    #../../common/common/global
    ../../common/darwin/global

    ../../common/darwin/users/yeldir
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
