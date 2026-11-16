{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix

    ../../shared/global
    ../shared/global

    ../shared/users/yeldir
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "datengrab";
    hostId = "36ab3def";
  };

  yeldirs = {
    system = {
      sops.enable = true;
      tailscale.enable = true;
      gitops = {
        enable = true;
        openFirewallForInterfaces = [
          "br-01c79d712ed8"
        ];
      };

      disks = {
        enable = true;
        initrd-ssh = {
          enable = true;
          ethernetDrivers = [
            "igb"
            "e1000e"
          ];
        };
        zfs = {
          enable = true;
          root = {
            encrypt = true;
            disk = "sdc";
            reservation = "";
            impermanenceRoot = true;
          };
          storage = {
            enable = true;
            disks = [
              "sda"
              "sdb"
              "sdd"
              "sde"
            ];
            mode = "raidz";
            reservation = "20GiB";
          };
        };
      };
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };

    borgbackup = {
      repos = {
        recreate = {
          path = "/storage/borg/recreate";
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE45YijDajl0VRD56CFDgvjDjfF+FuOQ4X3QiqaXfvPQ"
          ];
        };
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    logDriver = "json-file";

    # I use cadvisor to scrape metrics. cadvisor is incompatible with overlayfs,
    # which is the default.
    # https://github.com/google/cadvisor/issues/3772
    storageDriver = "overlay2";
    daemon.settings = {
      data-root = "/storage/docker";
    };
  };

  systemd.services.docker-prune-images = {
    description = "Prune Docker images";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker image prune --all --force";
    };
  };

  systemd.timers.docker-prune-images = {
    description = "Prune docker images daily at 2:00 AM UTC";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00 UTC";
      Persistent = true;
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
  system.stateVersion = "26.05"; # Did you read the comment?
}
