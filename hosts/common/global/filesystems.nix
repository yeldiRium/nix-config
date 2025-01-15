{
  boot.supportedFilesystems = ["nfs" "zfs" "ntfs"];
  boot.zfs.forceImportRoot = false;
  boot.zfs.allowHibernation = true;
}
