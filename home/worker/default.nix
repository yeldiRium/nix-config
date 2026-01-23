{ hostName }:
{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../shared
  ];

  wallpaper = pkgs.wallpapers.kitty-minimal-green;

  yeldirs = {
    system = {
      disable-impermanence = true;

      username = "worker";
      inherit hostName;
      platform = "linux";

      keyboardLayout = "de";
      keyboardVariant = "";
      keyring.enable = true;

      sops = {
        enable = true;
        sopsFile = ./secrets.yaml;
        keyFile = "${config.home.homeDirectory}/keys.txt";
      };
    };

    workerSupport = true;

    cli = {
      ops = {
        helm.enable = true;
        k9s.enable = true;
        kubectl.enable = true;
      };
      essentials = {
        enable = true;
        ssh.enable = false;
        git = {
          userEmail = "hannes.leutloff@yeldirium.de";
        };
        tmux = {
          autoQuit = true;
        };
        neovim = {
          supportedLanguages = [
            "bash"
            "docker"
            "go"
            "json"
            "lua"
            "nix"
            "yaml"
          ];

          layout = {
            indentation-guides.enable = true;
          };

          fold-cycle.enable = true;
          git.enable = true;
          illuminate.enable = true;
          lsp.enable = true;
          telescope.enable = true;
          treesitter.enable = true;
          undotree.enable = true;
          which-key.enable = true;
          yazi.enable = true;
          zoom.enable = true;
        };
      };
    };
  };

  home = {
    stateVersion = "25.05";
  };
}
