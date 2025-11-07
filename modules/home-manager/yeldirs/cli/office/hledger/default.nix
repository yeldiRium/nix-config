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
    assertions = [
      {
        assertion = config.yeldirs.cli.essentials.zsh.enableSecretEnv;
        message = "secret env must be activated for hledger to work";
      }
    ];

    yeldirs.cli.essentials.neovim.supportedLanguages = [
      "ledger"
    ];

    home = {
      packages = with pkgs; [
        hledger
        y.hledger-helpers-bash
        y.hledger-helpers-go
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
