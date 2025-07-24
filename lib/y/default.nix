{lib}: {
  colors = import ./colors.nix {inherit lib;};
  webbrowser = import ./webbrowser.nix {inherit lib;};
  workers = import ./workers.nix {inherit lib;};
}
