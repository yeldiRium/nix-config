{
  inputs,
  lib,
  ...
}: let
  addPatches = pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ patches;
    });
in {
  additions = final: prev: import ../pkgs {pkgs = final;};

  neovimPlugins = final: prev: {
    vimPlugins =
      prev.vimPlugins
      // {
      };
  };

  unstable-packages = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  zz-modifications = final: prev: {
    unstable =
      lib.updateManyAttrsByPath [
        {
          path = ["hyprlandPlugins" "hy3"];
          update = old: addPatches old [./hy3-0.43.0-disable-selection-hook.patch];
        }
      ]
      prev.unstable;
  };
}
