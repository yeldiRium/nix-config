{
  config,
  lib,
  pkgs,
  ...
}: {
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

  programs.vscode = {
    profiles.default = {
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
  };
}
