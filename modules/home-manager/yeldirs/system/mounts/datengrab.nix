{
  config,
  lib,
  ...
}:
let
  cfg = config.yeldirs.system.mounts.datengrab;
in
{
  options = {
    yeldirs.system.mounts.datengrab.enable =
      lib.mkEnableOption "Enable mount datengrab (requires mount to exist, adds bookmarks to file managers)";
  };
  config = {
    gtk.gtk3.bookmarks = lib.mkIf cfg.enable [
      "file:///mnt/datengrab"
    ];
  };
}
