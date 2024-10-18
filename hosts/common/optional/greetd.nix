{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  homeCfgs = config.home-manager.users;
  homeSharePaths = lib.mapAttrsToList (_: v: "${v.home.path}/share") homeCfgs;
  vars = ''XDG_DATA_DIRS="$XDG_DATA_DIRS:${lib.concatStringsSep ":" homeSharePaths}" GTK_USE_PORTAL=0'';

  yeldirCfg = homeCfgs.yeldir;

  sway-kiosk = command: "${lib.getExe pkgs.sway} --unsupported-gpu --config ${pkgs.writeText "kiosk.config" ''
    input * {
      xkb_layout "de"
    }
    output * bg #000000 solid_color
    xwayland disable
    input "type:touchpad" {
      tap enabled
    }
    exec '${vars} ${command}; ${pkgs.sway}/bin/swaymsg exit'
  ''}";
in {
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/programs/regreet.nix"
  ];
  disabledModules = [
    "programs/regreet.nix"
  ];

  users.extraUsers.greeter = {
    # For caching and such
    home = "/tmp/greeter-home";
    createHome = true;
  };

  programs.regreet = {
    enable = true;
    iconTheme = yeldirCfg.gtk.iconTheme;
    theme = yeldirCfg.gtk.theme;
    font = yeldirCfg.fontProfiles.regular;
    cursorTheme = {
      inherit (yeldirCfg.gtk.cursorTheme) name package;
    };
    settings.background = {
      path = yeldirCfg.wallpaper;
      fit = "Cover";
    };
  };
  services.greetd = {
    enable = true;
    settings.default_session.command = sway-kiosk (lib.getExe config.programs.regreet.package);
  };
}
