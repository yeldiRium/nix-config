{ pkgs, ... }: {
  imports = [
    ../shared
    ./shared
    ./shared/linux
  ];

  wallpaper = pkgs.wallpapers.kitty-minimal-green;

  yeldirs = {
    system = {
      hostName = "datengrab";
    };

    cli = {
      ops = {
        docker.enable = true;
        networking.enable = true;
        nix.enable = true;
      };
    };
  };

  home = {
    stateVersion = "26.05";
  };
}
