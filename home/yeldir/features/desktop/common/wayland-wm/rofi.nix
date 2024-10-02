{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "${config.fontProfiles.regular.name} ${toString config.fontProfiles.regular.size}";
    terminal = "${pkgs.kitty}/bin/kitty";
  };
}
