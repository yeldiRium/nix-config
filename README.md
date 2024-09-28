# yeldiR's nix config
## Setting up a new system
Using the nixos installer image...

1. Clone this repo and CD into it
2. Prepare the system disk using `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./host/<hostname>/disko.nix --arg device '"/dev/<system disk device>'"`
3. Optionally regenerate hardware configuration, if the system hardware changed, using `sudo nixos-generate-config --no-filesystems --show-hardware-config`
4. Put your sops keys into `/mnt/sops/age/keys.txt`
5. Install NixOs using `nixos-install --root /mnt --flake .#<hostname>`

This was written without testing. It might fail and after doing everything something might be missing in the persisted folders. Needs to be evaluated!