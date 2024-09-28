{pkgs, ...}: {
  programs = {
    swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      # TODO: colorscheme and ricing
    };
  };
}
