{
  pkgs,
  ...
}:
{
  imports = [
    ../shared
    ./shared
    ./shared/linux
  ];

  wallpaper = pkgs.wallpapers.nature-calm-valley;

  yeldirs = {
    system = {
      hostName = "nuc";

      mounts.datengrab.enable = false;
      keyring.enable = false;
    };

    cli = {
      ops = {
        docker.enable = true;
        nix.enable = true;
      };
    };

    desktop.enable = false;
  };

  home = {
    stateVersion = "25.11";
  };
}
