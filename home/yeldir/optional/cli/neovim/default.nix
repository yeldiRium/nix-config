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
    ./plugins/harpoon2.nix
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
  xdg.configFile."nvim/ftplugin/go.lua".source = pkgs.writeText "go.lua" (builtins.readFile ./ftplugin/go.lua);
  xdg.configFile."nvim/ftplugin/javascript.lua".source = pkgs.writeText "javascript.lua" (builtins.readFile ./ftplugin/javascript.lua);
  xdg.configFile."nvim/ftplugin/lua.lua".source = pkgs.writeText "lua.lua" (builtins.readFile ./ftplugin/lua.lua);
  xdg.configFile."nvim/ftplugin/nix.lua".source = pkgs.writeText "nix.lua" (builtins.readFile ./ftplugin/nix.lua);
  xdg.configFile."nvim/ftplugin/typescript.lua".source = pkgs.writeText "typescript.lua" (builtins.readFile ./ftplugin/typescript.lua);
}
