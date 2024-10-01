{
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.yeldir = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ifTheyExist [
      "audio"
      "git"
      "networkmanager"
      "video"
      "wheel"
    ];

    home = "/home/yeldir";
    createHome = true;

    hashedPasswordFile = config.sops.secrets.yeldir-password.path;
  };

  sops.secrets.yeldir-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.yeldir = import ../../../../home/yeldir/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = {};
  };
}
