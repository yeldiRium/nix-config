{hostName}: {pkgs, ...}: {
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
        keyFile = "/root/keys";
      };
    };

    cli = {
      ops = {
        lazydocker.enable = true;
      };
      essentials = {
        enable = true;
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
          ];

          layout = {
            indentation-guides.enable = true;
          };

          blamer.enable = true;
          fold-cycle.enable = true;
          git.enable = true;
          illuminate.enable = true;
          lsp.enable = true;
          oil.enable = true;
          quickfilepicker = {
            grapple.enable = true;
          };
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
