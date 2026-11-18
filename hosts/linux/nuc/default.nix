{
  imports = [
    ./hardware-configuration.nix

    ../../shared/global
    ../shared/global

    ../shared/users/yeldir
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nuc";
    hostId = "b4b6238f";
  };

  yeldirs = {
    system = {
      sops.enable = true;
      tailscale.enable = true;
      remote-shutdown.enable = true;
      networking = {
        enableNetworkManager = true;
      };
      gitops = {
        enable = true;
      };

      disks = {
        enable = true;
        initrd-ssh = {
          enable = true;
          enableWifi = true;
          ethernetDrivers = [
            "e1000e"
            "iwlwifi"
            "iwlmvm"
          ];
        };
        zfs = {
          enable = true;
          root = {
            encrypt = true;
            disk = "nvme0n1";
            reservation = "";
            impermanenceRoot = true;
          };
        };
      };
    };

    docker = {
      enable = true;
      enablePersistence = true;
      pruneImages = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
