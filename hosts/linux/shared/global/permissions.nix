{ config, lib, pkgs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.groups = {
    nix-ops = { };
  };

  security.sudo = {
    extraRules = [
      {
        groups = ifTheyExist [ "nix-ops" ];
        commands = [
          {
            command = lib.getExe pkgs.nixos-rebuild;
            options = [
              "SETENV"
              "NOPASSWD"
            ];
          }
        ];
      }
    ];
  };
}
