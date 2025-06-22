# yeldiR's nix config
## SOPS
I use sops to encrypt some data in git.
Not all hosts and users need this, but my primary user yeldir and my primary hosts do.

Each user and each host has its own age key.
So when adding a new host, it is necessary to put a list of age keys into /persist/sops/age/keys.txt or wherever configured, so that each required key is present.
For example to provision yeldir@recreate, which is my main host/user combo, the age keys for user-yeldir and for host-recreate are required.

## Setting up a new linux system
Using the nixos installer image...

1. Clone this repo and cd into the quickstart folder
2. Follow the [quickstart instructions](./quickstart/README.md)
3. Clone this repo again to /persist/home/yeldir/querbeet/workspace/nix-config (this is later mounted into your home directory and this config assumes that's where it's installed)
4. Add new host configuration and configure it according to your needs
    - **include the generated hardware-configuration.nix file**
    - don't forget to set the disko device
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

## Setting up a WSL system

I don't know if the hardware-configuration.nix changes depending on the host system. So far I assume that WSL is identical everywhere. YMMV.

The WSL setup does not use impermanence or sops, so no further setup and no encryption keys are required.

1. Prepare your system for WSL (install WSL latest version, enable optional features, whatever weird microsoft domain stuff your workstation requires)
2. Add a NixOS WSL instance according to [this guide](https://github.com/nix-community/NixOS-WSL) and start it
3. Clone this repo to ~/querbeet/workspace/nix-config, because it assumes that's where it's installed
4. Set your git username/email and gpg signing key in the [wsl home config](./home/nixos/wsl.nix)
5. Run `nixos-rebuild switch --flake ~/querbeet/workspace/nix-config#wsl --impure`
6. Restart WSL to be sure
7. Optional: If you want to use commit signing, import your private key

## Assumed filesystem

Some parts of this config assume certain paths are present in the system,
because that is how I structure my systems. These paths are:

- ~/querbeet/nextcloud
- ~/querbeet/stuff/temp
- ~/querbeet/workspace/ledger
- ~/querbeet/workspace/nix-config
- ~/querbeet/workspace/obsidian
- ~/querbeet/workspace/private/qmk_firmware
- ~/querbeet/workspace/vendor
