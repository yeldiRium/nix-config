{ pkgs }:
{
  fold-cycle-nvim = pkgs.callPackage ./fold-cycle-nvim { };
  symbols-nvim = pkgs.callPackage ./symbols-nvim { };
}
