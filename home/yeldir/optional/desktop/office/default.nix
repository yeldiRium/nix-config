{ pkgs, ... }:
{
  imports = [
    ./calendar.nix
    ./calibre.nix
    ./contacts.nix
    ./email.nix
    ./hledger.nix
    ./libreoffice.nix
    ./nextcloud.nix
    ./obsidian.nix
  ];

  home.packages = with pkgs; [
    speedcrunch
  ];
}
