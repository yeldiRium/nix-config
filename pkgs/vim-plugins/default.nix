{ pkgs }:
{
  fold-cycle-nvim = pkgs.callPackage ./fold-cycle-nvim { };
  screenkey-nvim = pkgs.callPackage ./screenkey-nvim { };
  symbols-nvim = pkgs.callPackage ./symbols-nvim { };
}
