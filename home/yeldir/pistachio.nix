{
  lib,
  ...
}:
{
  imports = [
    ../shared
    ./shared
    ./shared/linux
  ];

  colorscheme.source = "#93c572";

  yeldirs = {
    system = {
      hostName = "pistachio";

      mounts.datengrab.enable = false;
      keyring.enable = lib.mkForce false;
    };

    cli = {
      essentials.git.signCommits = false;

      ops = {
        docker.enable = true;
        nix.enable = true;
      };
    };

    desktop.enable = false;
  };

  home = {
    stateVersion = "26.05";
  };
}
