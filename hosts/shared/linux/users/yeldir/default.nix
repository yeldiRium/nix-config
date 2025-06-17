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
    ../../../common/optional/home-manager.nix
  ];

  users.mutableUsers = false;
  users.users.yeldir = {
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

    home = "/home/yeldir";
    createHome = true;

    hashedPasswordFile = config.sops.secrets.yeldir-password.path;

    openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf4PuMuh6umz5hvl3u0sT20TP6+EKnOHKjy3uUjYCMjXMtjC83u5TKEl//oZ70g96Kn5w3KEN169ektClvHFJx8nOiZXAI617xVjTkYHtbpDaZOyaPNER23TQ+BNDarhAjtY9RAjgsO0M0wqfg69ElP6+UFl/MM+txjGnf3NasaDto5/bRNIBssBg++FI9xUHW/urD6hddRZ8iBIHxud8qezM9/a6+Q2/5AhBOmJy4MysWea1PP8jA2kbSDjUCNGA4w24pJzyVU8qB8WMWfIkkvUFCSQ/o0UZ133eoEZBGdTMW/oxI/wsUOqyBvbAkpJWPJH4LQqfopLfPjguI5QXj hannes.leutloff@yeldirium.de"
    ];
  };

  sops.secrets.yeldir-password = {
    sopsFile = ../../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.yeldir = import ../../../../../home/yeldir/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = {};
  };
}
