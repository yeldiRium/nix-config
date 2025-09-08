{ pkgs, ... }:
{
  fontProfiles = {
    enable = true;
    monospace = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
    };
    regular = {
      name = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
