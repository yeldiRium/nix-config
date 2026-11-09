{ lib, ... }:
let
  workers = lib.mapAttrs (
    _: cfg:
    let
      hostName = "worker-${cfg.shortname}";
    in
    cfg
    // {
      inherit hostName;
      hostId = "000${cfg.shortname}";
    }
  ) (lib.strings.fromJSON (lib.readFile ../../workers.json));
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
    primaryName = lib.getAttr "hostName" (lib.head (lib.filter (w: w.k3s.clusterInit) workersList));
  };
}
