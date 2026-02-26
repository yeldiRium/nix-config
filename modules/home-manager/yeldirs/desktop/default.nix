{ lib, ... }:
{
  imports = [
    ./communication
    ./essentials
    ./games
    ./media
    ./office
  ];

  options = {
    yeldirs.desktop = {
      enable = lib.mkEnableOption "desktop";
    };
  };
}
