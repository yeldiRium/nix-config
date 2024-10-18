{inputs, ...}: let
  addPatches = pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ patches;
    });
in {
  additions = final: prev: import ../pkgs {pkgs = final;};

  unstable-packages = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  modifications = final: prev: {
    hyprlandPlugins.hy3 = addPatches prev.hyprlandPlugins.hy3 [./hy3-disable-selection-hook.patch];
  };
}
