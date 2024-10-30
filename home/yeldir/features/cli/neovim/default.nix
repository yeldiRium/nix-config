{config, pkgs, ...}: let
  reloadNvim = ''
    XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
    for server in $XDG_RUNTIME_DIR/nvim.*; do
      nvim --server $server --remote-send '<Esc>:source $MYVIMRC<CR>' &
    done
  '';
in {
  imports = [
    #./plugins/colorscheme.nix # maybe delete this, if I keep liking the auto generated theme
    ./plugins/neogit.nix
    ./plugins/rnvimr.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
  ];

  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = /* vim */ ''
      source ~/.config/nvim/color.vim
    '';

    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
      ${builtins.readFile ./bindings.lua}
    '';
  };

  xdg.configFile."nvim/color.vim".source = pkgs.writeText "color.vim" (import ./theme.nix config.colorscheme);
  xdg.configFile."nvim/color.vim".onChange = reloadNvim;
  xdg.configFile."nvim/init.lua".onChange = reloadNvim;
}
