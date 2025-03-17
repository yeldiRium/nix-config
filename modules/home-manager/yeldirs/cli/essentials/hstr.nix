{
  config,
  lib,
  ...
}: let
  cfg = config.yeldirs.cli.essentials.hstr;
  yeldirsCfg = config.yeldirs;
in {
  options = {
    yeldirs.cli.essentials.hstr.enable = lib.mkEnableOption "hstr";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      hstr = {
        enable = true;

        # The ZSH integration contains things I don't want like the keybinding
        # for emacs mode. Since it is impossible to add lines to .zshrc after
        # the hstr integration, I disable it and reproduce it myself.
        enableZshIntegration = false;
      };

      zsh.initExtra = lib.mkIf yeldirsCfg.cli.essentials.zsh.enable ''
        # HSTR configuration - add this to ~/.zshrc
        setopt histignorespace           # skip cmds w/ leading space from history
        export HSTR_CONFIG=hicolor,prompt-bottom,raw-history-view
        export HSTR_TIOCSTI=y

        bindkey -s  "\C-r" "^[[1~ hstr -- \C-j" # CUSTOM binding for vi mode
      '';
    };
  };
}
