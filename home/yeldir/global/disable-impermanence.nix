{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.disable-impermanence;
in {
  options = {
    yeldirs.disable-impermanence = lib.mkEnableOption "disable-impermanence";
  };
  config = {
    home.persistence."/persist/${config.home.homeDirectory}" = lib.mkIf cfg (lib.mkForce {});
  };
}
