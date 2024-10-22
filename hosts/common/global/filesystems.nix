{
  boot.supportedFilesystems = ["nfs" "zfs" "nfts"];
  boot.zfs.forceImportRoot = false;
  boot.zfs.allowHibernation = true;
}
