{ pkgs }:
{
  fold-cycle-nvim = pkgs.callPackage ./fold-cycle-nvim { };
  symbols-nvim = pkgs.callPackage ./symbols-nvim { };
  wayfinder-nvim = pkgs.callPackage ./wayfinder-nvim { };
}
