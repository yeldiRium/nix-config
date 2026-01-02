{
  inputs,
  ...
}:
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
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };
  unstable-packages = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
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

  # Remove this once citrix fixes their dependencies.
  # https://github.com/NixOS/nixpkgs/issues/454151
  zz03-modifications = final: _: {
    pinned-citrix =
      import
        (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/29b6e7097f50955f49a81d2665fb21c94c43df19.tar.gz";
          sha256 = "0zrkfxj130gbgixgk8yaxk5d9s5ppj667x38n4vys4zxw5r60bjz";
        })
        {
          inherit (final.stdenv.hostPlatform) system;
          config = {
            allowUnfree = true;
            allowInsecure = true;
            permittedInsecurePackages = [
              "libsoup-2.74.3"
            ];
          };
        };
  };
}
