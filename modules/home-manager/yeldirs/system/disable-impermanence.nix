{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.system.disable-impermanence;
in {
  options = {
    yeldirs.system.disable-impermanence = lib.mkEnableOption "disable-impermanence";
  };
  config = {
    home.persistence."/persist/${config.home.homeDirectory}" = lib.mkIf cfg (lib.mkForce {});
  };
}
