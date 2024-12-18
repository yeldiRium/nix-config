# yeldiR's nix config
## Setting up a new system
Using the nixos installer image...

1. Clone this repo and cd into the quickstart folder
2. Follow the [quickstart instructions](./quickstart/README.md)
3. Clone this repo again to your favorite location (my default is /home/yeldir/querbeet/workspace/nix-config)
4. Add new host configuration and configure it according to your needs
    - **include the generated hardware-configuration.nix file**
5. Put your sops keys into `/persist/sops/age/keys.txt`
6. Create all folders defined in hosts/common/global/persistence.nix. (I'll try to automate this)
7. nboot & reboot
8. Add ssh key
9. `chmod -R 700 ~/.gnupg` (I'll try to automate this)
10. Import private gpg key matching above fingerprint
11. Create a new keyring using seahorse and mark it as default
12. Reboot
13. Application specific setup
  1. Chrome - Log in, enable sync for extensions and settings
    - Log into 1password
  2. Thunderbird - import public gpg key (this somehow can't be avoided)
  3. VSCode - log into GitHub account, Copilot
  4. `qmk setup yeldiRium/qmk_firmware`

This was written without testing. It might fail and after doing everything something might be missing in the persisted folders. Needs to be evaluated!
