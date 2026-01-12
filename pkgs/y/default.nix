{ pkgs }:
{
  aws-ssm-tools = pkgs.callPackage ./aws-ssm-tools.nix { };
  docker-volume-backup = pkgs.callPackage ./docker-volume-backup { };
  docker-volume-copy = pkgs.callPackage ./docker-volume-copy { };
  docker-volume-inspect = pkgs.callPackage ./docker-volume-inspect { };
  git-find-default-branch = pkgs.unstable.callPackage ./git-find-default-branch { };
  git-find-remote = pkgs.unstable.callPackage ./git-find-remote { };
  git-spin-off-branch = pkgs.unstable.callPackage ./git-spin-off-branch { };
  golangci-lint-langserver = pkgs.callPackage ./golangci-lint-langserver.nix { };
  hledger-helpers-bash = pkgs.callPackage ./hledger-helpers-bash { };
  hledger-helpers-go = pkgs.unstable.callPackage ./hledger-helpers-go { };
  hledger-language-server = pkgs.callPackage ./hledger-language-server.nix { };
  k8s-scripts = pkgs.callPackage ./k8s-scripts { };
  konfig = pkgs.callPackage ./konfig.nix { };
  shellScript = pkgs.callPackage ./shellScript.nix { };
  taws = pkgs.callPackage ./taws.nix { };
  watchcmd = pkgs.callPackage ./watchcmd { };
}
