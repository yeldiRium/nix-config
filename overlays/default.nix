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

  unstable-packages = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  zz-modifications = _: prev: {
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
}
