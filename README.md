# yeldiR's nix config
## Setting up a new system
Using the nixos installer image...

1. Follow the vimjoyer tutorial until the first reboot
2. Clone this repo and CD into it
3. Put your sops keys into `/mnt/sops/age/keys.txt`
4. Install NixOs using `nixos-install --root /mnt --flake .#<hostname>`
5. Reboot
6. Add ssh key
7. Import private gpg key matching above fingerprint
8. Initialize pass store using `pass init "8DFC1FE97A49B7CEF042DE06BA239C4139A9A514"`

This was written without testing. It might fail and after doing everything something might be missing in the persisted folders. Needs to be evaluated!
