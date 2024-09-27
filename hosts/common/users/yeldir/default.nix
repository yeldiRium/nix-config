{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.yeldir = {
    initialPassword = "12345";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ifTheyExist [
      "audio"
      "docker"
      "git"
      "networkmanager"
      "video"
      "wheel"
    ];

    packages = [
      pkgs.home-manager
    ];
  };

  home-manager.users.yeldir = import ../../../../home/yeldir/${config.networking.hostName}.nix;
}
