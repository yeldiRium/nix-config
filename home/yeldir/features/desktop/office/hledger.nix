{pkgs, ...}: {
  home = let
    hltool = name: (pkgs.writeShellScriptBin name (builtins.readFile ./hledger-scripts/${name}.sh));
  in {
    packages = with pkgs; [
      hledger
      (hltool "hlb")
      (hltool "hlbeom")
      (hltool "hlbudget")
      (hltool "hlcompare")
      (hltool "hlevents")
      (hltool "hlforecast")
      (hltool "hlmonthend")
      (hltool "hlprojects")
    ];
    sessionVariables = {
      LEDGER_FILE = "$HOME/querbeet/workspace/ledger/all.journal";
    };
  };
}
