{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence

    ./backup.nix
    ./disable-impermanence.nix
    ./networking.nix
    ./sops.nix
    ./tailscale.nix
  ];
}
