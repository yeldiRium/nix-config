{
  config,
  pkgs,
  ...
}: let
  vimConfigPath = "${config.home.homeDirectory}/.config/nvim/init.lua";
  reloadNvim = ''
    XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
    for server in $XDG_RUNTIME_DIR/nvim.*; do
      nvim --server $server --remote-send '<Esc>:source ${vimConfigPath}<CR>' &
    done
  '';
in {
  imports = [
    ./plugins/lsp.nix
    ./plugins/neogit.nix
    ./plugins/rnvimr.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
    ./plugins/undotree.nix
  ];

  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig =
      /*
      vim
      */
      ''
        source ~/.config/nvim/color.vim
      '';

    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
      ${builtins.readFile ./bindings.lua}
    '';
  };

  xdg.configFile."nvim/color.vim".onChange = reloadNvim;
  xdg.configFile."nvim/init.lua".onChange = reloadNvim;
  xdg.configFile."nvim/color.vim".source = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
  xdg.configFile."nvim/ftplugin/nix.lua".source = pkgs.writeText "nix.lua" (builtins.readFile ./ftplugin/nix.lua);
  xdg.configFile."nvim/ftplugin/go.lua".source = pkgs.writeText "go.lua" (builtins.readFile ./ftplugin/go.lua);
}
