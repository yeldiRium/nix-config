{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    prismlauncher
  ];

  home.persistence = {
    "/persist/${config.home.homeDirectory}" = {
      allowOther = true;
      directories = [
        ".local/share/PrismLauncher"
      ];
    };
  };
}
