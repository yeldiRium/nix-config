{...}: {
  workers = builtins.readFile ../workers.json |> builtins.fromJSON;

  ips = builtins.mapAttrsToList (worker: workerCfg: workerCfg.ipv6) .workers;
}
