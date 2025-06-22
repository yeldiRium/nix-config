{
  config,
  inputs,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    inputs.home-manager.nixosModules.default
    ../../../../shared/optional/home-manager.nix
  ];

  users.mutableUsers = false;
  users.users.worker = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ifTheyExist [
      "docker"
      "git"
      "wheel"
    ];

    home = "/home/worker";
    createHome = true;

    openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIdBRHumfvCkSAahB73ERlXNi5Ro6oBGsk3nqgOG0u1 hannes.leutloff@yeldirium.de"
    ];
  };

  home-manager.users.worker = (import ../../../../../home/worker { hostName = config.networking.hostName; });
}
