{ pkgs }:
{
  fold-cycle-nvim = pkgs.callPackage ./fold-cycle-nvim { };
  no-go-nvim = pkgs.callPackage ./no-go-nvim { };
  screenkey-nvim = pkgs.callPackage ./screenkey-nvim { };
}
