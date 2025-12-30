{
  config,
  lib,
  ...
}:
let
  cfg = config.yeldirs.system.disable-impermanence;
in
{
  options = {
    yeldirs.system.disable-impermanence = lib.mkEnableOption "disable-impermanence";
  };
  config = {
    environment.persistence."/persist/system" = lib.mkIf cfg (lib.mkForce { });
  };
}
