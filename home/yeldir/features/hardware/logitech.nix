{pkgs, ...}: {
  home.packages = with pkgs; [
    solaar
  ];
}