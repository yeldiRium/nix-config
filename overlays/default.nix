{inputs, ...}: {
  additions = final: _: import ../pkgs final.pkgs;

  unstable-packages = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
