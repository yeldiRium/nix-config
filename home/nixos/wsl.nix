{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../shared
  ];

  wallpaper = pkgs.wallpapers.cyberpunk-living-quarter;

  yeldirs = {
    system = {
      disable-impermanence = true;

      username = "nixos";
      hostName = "recreate-wsl";
      platform = "linux";

      keyboardLayout = "de";
      keyboardVariant = "";

      keyring.enable = true;
    };

    cli = {
      essentials = {
        enable = true;
        git = {
          userEmail = "hannes.leutloff@yeldirium.de";
          signCommits = false;
          signingKey = "";
        };
        ssh = {
          excludePrivate = false;
        };

        neovim = {
          supportedLanguages = [
            "bash"
            "docker"
            "go"
            "json"
            "ledger"
            "lua"
            "markdown"
            "nix"
            "yaml"
          ];

          layout = {
            indentation-guides.enable = true;
          };

          blamer.enable = true;
          copilot.enable = false;
          debugging.enable = true;
          fold-cycle.enable = true;
          git.enable = true;
          illuminate.enable = true;
          lsp.enable = true;
          oil.enable = true;
          quickfilepicker = {
            grapple.enable = true;
          };
          telescope.enable = true;
          testing.enable = true;
          treesitter.enable = true;
          undotree.enable = true;
          which-key.enable = true;
          yazi.enable = true;
          zoom.enable = true;
        };
        yazi = {
          enableGui = true;
        };
      };
      
      development = {
        gh.enable = true;
      };

      ops = {
        lazydocker.enable = true;
      };
    };
  };

  home = {
    shellAliases = {
      nbuild = lib.mkForce "sudo nixos-rebuild build --flake $FLAKE#wsl --impure";
      nboot = lib.mkForce "sudo nixos-rebuild boot --flake $FLAKE#wsl --impure";
      nswitch = lib.mkForce "sudo nixos-rebuild switch --flake $FLAKE#wsl --impure";
      nrepl = lib.mkForce "sudo nixos-rebuild repl --flake $FLAKE#wsl --impure";
      nrollback = lib.mkForce "sudo nixos-rebuild switch --flake $FLAKE#wsl --impure --rollback";
    };
  };

  home = {
    stateVersion = "24.05";
  };
}
