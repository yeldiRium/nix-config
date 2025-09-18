{ pkgs }:
{
  konfig = pkgs.callPackage ./konfig.nix { };
  hledger-language-server = pkgs.callPackage ./hledger-language-server.nix { };
  ijq = pkgs.callPackage ./ijq.nix { };
  shellScript = pkgs.callPackage ./shellScript.nix { };
}
