{
  imports = [
    ./plugins/neogit.nix
    ./plugins/telescope.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
      ${builtins.readFile ./bindings.lua}
    '';
  };
}
