{lib, ...}: {
  imports = [
    ./cli
    ./desktop
    ./system
  ];
  options = {
    yeldirs.workerSupport = lib.mkEnableOption "support for managing and working with worker servers";
  };
}
