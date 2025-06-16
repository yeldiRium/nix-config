{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.default
    ../../../common/optional/home-manager.nix
  ];

  users.users.yeldir = {
    shell = pkgs.zsh;

    home = "/Users/yeldir";
    createHome = true;
  };

  home-manager.users.yeldir = import ../../../../../home/yeldir/${config.networking.hostName}.nix;
}
