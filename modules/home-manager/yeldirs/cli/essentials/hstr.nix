{
  config,
  lib,
  ...
}: let
  essentials = config.yeldirs.cli.essentials;
in {
  config = lib.mkIf essentials.enable {
    programs = {
      hstr = {
        enable = true;

        # The ZSH integration contains things I don't want like the keybinding
        # for emacs mode. Since it is impossible to add lines to .zshrc after
        # the hstr integration, I disable it and reproduce it myself.
        enableZshIntegration = false;
      };

      zsh.initExtra = lib.mkIf config.programs.zsh.enable ''
        # HSTR configuration - add this to ~/.zshrc
        setopt histignorespace           # skip cmds w/ leading space from history
        export HSTR_CONFIG=hicolor,prompt-bottom,raw-history-view
        export HSTR_TIOCSTI=y
        export HISTFILE=${config.programs.zsh.history.path}

        bindkey -s  "\C-r" "^[[1~ hstr -- \C-j" # CUSTOM binding for vi mode
      '';
    };
  };
}
