{ lib, ... }:
let
  workers =
    lib.readFile ../../workers.json
    |> lib.strings.fromJSON
    |> lib.mapAttrs (
      _: cfg:
      let
        hostName = "worker-${cfg.shortname}";
      in
      cfg
      // {
        inherit hostName;
        hostId = "000${cfg.shortname}";
      }
    );
  workersList = lib.attrValues workers;
  serverList = lib.filter (w: w.k3s.server) workersList;
  each = f: lib.map (workerCfg: f workerCfg) workersList;
in
{
  inherit
    workers
    workersList
    serverList
    each
    ;

  count = lib.length workersList;
  serverCount = lib.length serverList;

  eachToAttrs = f: lib.listToAttrs (each f);

  ips = lib.map (workerCfg: workerCfg.ipv6) workersList;

  k3s = {
    primaryName = lib.filter (w: w.k3s.clusterInit) workersList |> lib.head |> lib.getAttr "hostName";
  };
}
