{ pkgs, ... }@args:
{
  konfig = pkgs.callPackage ./konfig.nix { };
  hledger-language-server = pkgs.callPackage ./hledger-language-server.nix { };
  ijq = pkgs.callPackage ./ijq.nix args;
  shellScript = pkgs.callPackage ./shellScript.nix args;
}
