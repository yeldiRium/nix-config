{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence

    ./backup.nix
    ./disable-impermanence.nix
    ./gitops.nix
    ./networking.nix
    ./sops.nix
    ./tailscale.nix
  ];
}
