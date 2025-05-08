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
      hostName = "wsl";
      platform = "linux";

      keyboardLayout = "de";
      keyboardVariant = "";
    };

    cli = {
      essentials = {
        enable = true;
        git = {
          userEmail = "tbd";
          signCommits = true;
          signingKey = "tbd";
        };
        ssh = {
          excludePrivate = true;
        };

        neovim = {
          supportedLanguages = [
            "bash"
            "docker"
            "go"
            "javascript"
            "json"
            "lua"
            "markdown"
            "nix"
            "typescript"
            "yaml"
          ];

          layout = {
            indentation-guides.enable = true;
          };

          copilot.enable = true;
          debugging.enable = true;
          early-retirement.enable = true;
          fold-cycle.enable = true;
          git.enable = true;
          illuminate.enable = true;
          lsp.enable = true;
          quickfilepicker.grapple.enable = true;
          telescope.enable = true;
          testing.enable = true;
          treesitter.enable = true;
          undotree.enable = true;
          wsl-clipboard.enable = true;
          zoom.enable = true;
        };
      };

      development = {
        go-task.enable = true;
      };

      ops = {
        crossplane.enable = true;
        k9s.enable = true;
        kubectl.enable = true;
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
