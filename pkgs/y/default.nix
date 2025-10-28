{ pkgs }:
{
  aws-ssm-tools = pkgs.callPackage ./aws-ssm-tools.nix { };
  git-find-default-branch = pkgs.unstable.callPackage ./git-find-default-branch { };
  git-find-remote = pkgs.unstable.callPackage ./git-find-remote { };
  golangci-lint-langserver = pkgs.callPackage ./golangci-lint-langserver.nix { };
  konfig = pkgs.callPackage ./konfig.nix { };
  hledger-language-server = pkgs.callPackage ./hledger-language-server.nix { };
  shellScript = pkgs.callPackage ./shellScript.nix { };
  watchcmd = pkgs.callPackage ./watchcmd { };
}
