{lib, ...}: {
  workers = let
    workersFile = builtins.readFile ../workers.txt;
    workersUnfiltered = lib.splitString "\n" workersFile;
    workers = lib.filter (worker: worker != "") workersUnfiltered;

    workersParsed = lib.map (workerLine: let
      parts = lib.splitString " " workerLine;
    in {
      shortName = lib.elemAt parts 0;
      ipv6 = lib.elemAt parts 1;
    }) workers;
  in
    workersParsed;

  ips = map (worker: worker.ipv6) .workers;
}
