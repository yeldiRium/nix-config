{config, lib, ...}: let
  cfg = config.yeldirs.cli.zsh;
in {
  options = {
    yeldirs.cli.zsh.enableSecretEnv = lib.mkOption {
      type = lib.types.bool;
      description = "Requires sops to be enabled. Mounts ~/.secretenv from the sops secrets.";
      default = false;
    };
  };
  config = {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "wd"
          ];
        };

        # Source secrets that are mounted via sops
        envExtra = lib.mkIf cfg.enableSecretEnv "source ~/.secretenv";
      };
    };

    home = {
      persistence = {
        "/persist/${config.home.homeDirectory}" = {
          files = [
            ".warprc"
            ".zsh_history"
          ];
        };
      };
    };

    sops = lib.mkIf cfg.enableSecretEnv {
      secrets.secretenv = {
        path = "${config.home.homeDirectory}/.secretenv";
      };
    };
  };
}
