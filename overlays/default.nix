{
  inputs,
  lib,
  ...
}:
let
  addPatches =
    pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ patches;
    });
in
{
  additions =
    final: prev:
    import ../pkgs { pkgs = final; }
    // {
      vimExtraPlugins = (prev.vimExtraPlugins or { }) // import ../pkgs/vim-plugins { pkgs = final; };
      tmuxExtraPlugins = (prev.tmuxExtraPlugins or { }) // import ../pkgs/tmux-plugins { pkgs = final; };
    };

  staging-packages = final: _: {
    staging = import inputs.nixpkgs-staging {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
  unstable-packages = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  zz01-modifications = _: prev: {
    unstable = lib.updateManyAttrsByPath [
      {
        path = [
          "hyprlandPlugins"
          "hy3"
        ];
        update = old: addPatches old [ ./hy3-0.43.0-disable-selection-hook.patch ];
      }
    ] prev.unstable;
  };
  # Remove this once neotest has a working version again.
  # https://github.com/nvim-neotest/neotest/issues/530
  zz02-modifications = _: prev: {
    unstable = prev.unstable // {
      luaPackages = prev.unstable.luaPackages // {
        neotest = prev.unstable.luaPackages.neotest.override {
          doCheck = false;
        };
      };
    };
  };
}
