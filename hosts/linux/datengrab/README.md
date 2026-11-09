# datengrab
## Install command

0. Clone this repo anywhere
1. Format disks with `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount --flake .#datengrab`
2. Move nix config to /mnt/home/yeldir/querbeet/workspace/nix-config
3. Put age key in /mnt/persist/sops/age/keys.txt
4. Install nixos using `sudo nixos-install --flake .#datengrab`
