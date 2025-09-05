{pkgs ? import <nixpkgs> {}, ...}: rec {
  # My wallpaper collection
  wallpapers = import ./wallpapers {inherit pkgs;};
  allWallpapers = pkgs.linkFarmFromDrvs "wallpapers" (pkgs.lib.attrValues wallpapers);

  # And colorschemes based on it
  generateColorscheme = import ./colorschemes/generator.nix {inherit pkgs;};
  colorschemes = import ./colorschemes {inherit pkgs wallpapers generateColorscheme;};
  allColorschemes = let
    # This is here to help us keep IFD cached (hopefully)
    combined = pkgs.writeText "colorschemes.json" (builtins.toJSON (pkgs.lib.mapAttrs (_: drv: drv.imported) colorschemes));
  in
    pkgs.linkFarmFromDrvs "colorschemes" (pkgs.lib.attrValues colorschemes ++ [combined]);

  hledger-language-server = pkgs.callPackage ./hledger-language-server.nix {};
  konfig = pkgs.callPackage ./konfig.nix {};

  y = import ./y {inherit pkgs;};
}
