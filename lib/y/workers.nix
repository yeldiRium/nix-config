{lib, ...}: {
  workers = lib.readFile ../../workers.json |> lib.strings.fromJSON;

  ips = lib.mapAttrsToList (worker: workerCfg: workerCfg.ipv6) .workers;
}
