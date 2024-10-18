{pkgs, ...}: {
  home = let
    hltool = name:
      pkgs.writeTextFile {
        inherit name;
        executable = true;
        destination = "/bin/${name}";
        text = builtins.readFile ./hledger-scripts/${name}.sh;
        checkPhase = ''
          ${pkgs.stdenv.shellDryRun} "$target"
        '';
        meta.mainProgram = name;
      };
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
