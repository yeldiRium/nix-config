{lib, ...}: let
  workers = lib.readFile ../../workers.json |> lib.strings.fromJSON;
  each = f: lib.mapAttrsToList (_: workerCfg: f workerCfg) workers;
in {
  inherit workers each;

  eachToAttrs = f: lib.listToAttrs (each f);

  ips = lib.mapAttrsToList (worker: workerCfg: workerCfg.ipv6) workers;
}
