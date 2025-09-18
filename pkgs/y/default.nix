{ pkgs }:
{
  aws-ssm-tools = pkgs.callPackage ./aws-ssm-tools.nix { };
  konfig = pkgs.callPackage ./konfig.nix { };
  hledger-language-server = pkgs.callPackage ./hledger-language-server.nix { };
  shellScript = pkgs.callPackage ./shellScript.nix { };
}
