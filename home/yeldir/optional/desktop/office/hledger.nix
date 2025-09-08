{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      hledger
      (y.shellScript ./hledger-scripts/hlc)
      (y.shellScript ./hledger-scripts/hlb)
      (y.shellScript ./hledger-scripts/hlbudget)
      (y.shellScript ./hledger-scripts/hlcompare)
      (y.shellScript ./hledger-scripts/hlevents)
      (y.shellScript ./hledger-scripts/hlprojects)
    ];
    shellAliases = {
      "hl" = "hledger";
    };
    sessionVariables = {
      LEDGER_FILE = "$HOME/querbeet/workspace/ledger/current.journal";
    };
  };
}
