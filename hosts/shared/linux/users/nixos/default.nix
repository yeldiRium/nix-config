{
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # This user is exclusively intended for use in WSL.

  users.mutableUsers = true;
  users.users.nixos = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ifTheyExist [
      "docker"
      "git"
      "wheel"
    ];

    home = "/home/nixos";
    createHome = true;

    linger = true;
  };

  home-manager.users.nixos = import ../../../../../home/nixos/wsl.nix;
}
