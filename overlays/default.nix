{inputs, ...}: {
  additions = final: prev: import ../pkgs {pkgs = final;};

  unstable-packages = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
