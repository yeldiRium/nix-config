{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.office.hledger;
in
{
  options = {
    yeldirs.cli.office.hledger = {
      enable = lib.mkEnableOption "hledger";
    };
  };

  config = lib.mkIf cfg.enable {
    yeldirs.cli.essentials.neovim.supportedLanguages = [
      "ledger"
    ];

    home = {
      packages = with pkgs; [
        hledger
        (y.shellScript ./scripts/hlc)
        (y.shellScript ./scripts/hlb)
        (y.shellScript ./scripts/hlbudget)
        (y.shellScript ./scripts/hlcompare)
        (y.shellScript ./scripts/hlevents)
        (y.shellScript ./scripts/hlprojects)
      ];

      shellAliases = {
        "hl" = "hledger";
      };

      sessionVariables = {
        LEDGER_FILE = "$HOME/querbeet/workspace/ledger/current.journal";
      };
    };
  };
}
