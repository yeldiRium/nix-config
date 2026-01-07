{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  # This module passes parameters through to the nixCat setup under
  # /flakes/y-editor.
  # It is a thin wrapper that allows settings to be overridden by home-manager
  # configs. It also allows for sharing of settings by merging all set values.

  options = {
    yeldirs.cli.essentials.nixCats = lib.mkOption {
      type = lib.types.anything;
      default = { };
    };
  };

  config =
    let
      basePackage = inputs.y-editor.packages.${pkgs.stdenv.hostPlatform.system}.default;
      inherit (basePackage.passthru) utils;
    in
    {
      home.packages = [
        (basePackage.override (prev: {
          packageDefinitions = prev.packageDefinitions // {
            neovim = utils.mergeCatDefs prev.packageDefinitions.neovim (_: {
              categories = config.yeldirs.cli.essentials.nixCats;
            });
          };
        }))
      ];
    };
}
