{ pkgs, ... }:
{
  imports = [
    ./calendar.nix
    ./contacts.nix
    ./email.nix
  ];

  home.packages = with pkgs; [
    speedcrunch
  ];
}
