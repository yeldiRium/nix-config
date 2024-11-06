{
  config,
  lib,
  pkgs,
  ...
}: {
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
      (hltool "hlc")
      (hltool "hlb")
      (hltool "hlbeom")
      (hltool "hlbudget")
      (hltool "hlcompare")
      (hltool "hlevents")
      (hltool "hlforecast")
      (hltool "hlmonthend")
      (hltool "hlprojects")
    ];
    shellAliases = {
      "hl" = "hledger";
    };
    sessionVariables = {
      LEDGER_FILE = "$HOME/querbeet/workspace/ledger/all.journal";
    };
  };

  programs.vscode = {
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "ledger";
        publisher = "mariosangiorgio";
        version = "1.0.9";
        sha256 = "sha256:1lyhldyl4f1c2hxqwn6arma8p1snm2cbrdr1vybxllrh570lcgz9";
      }
    ];
    userSettings = lib.optionalAttrs config.programs.vscode.enable {
      "ledger.binary" = "${lib.getExe pkgs.hledger}";
      "files.associations" = {
        "*.journal" = "ledger";
        "*.prices" = "ledger";
      };
      "[ledger]" = {
        "editor.rulers" = [54];
      };
    };
  };
}
