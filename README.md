# yeldiR's nix config
## Setting up a new system
Using the nixos installer image...

1. Clone this repo and cd into the quickstart folder
2. Follow the [quickstart instructions](./quickstart/README.md)
3. Add new host configuration and configure it according to your needs
4. Put your sops keys into `/persist/sops/age/keys.txt`
5. nboot & reboot
6. Add ssh key
7. Import private gpg key matching above fingerprint
8. Create a new keyring using seahorse and mark it as default
9. Reboot
10. Application specific setup
  1. Chrome - Log in, enable sync for extensions and settings
    - Log into 1password
  2. Thunderbird - create accounts, import gpg key (unfortunately this seems unavoidable)
  3. VSCode - log into GitHub account, Copilot

This was written without testing. It might fail and after doing everything something might be missing in the persisted folders. Needs to be evaluated!
