{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.yeldirs.cli.development;
in
{
  config = lib.mkIf (cfg.copilot.enable || cfg.claude.enable) {
    home = {
      packages = with pkgs; [
        y.mcp-atlassian
      ];
    };
  };
}
