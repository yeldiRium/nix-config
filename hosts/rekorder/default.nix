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
    #../common/global

    #../common/users/yeldir
  ];

  environment.systemPackages = with pkgs; [
    kitty
    ranger
    neovim
  ];

  nix.extraOptions = ''
    auto-optimise-store = true
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
