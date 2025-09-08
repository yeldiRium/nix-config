{
  boot.supportedFilesystems = [
    "nfs"
    "zfs"
    "ntfs"
    "ext4"
  ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.allowHibernation = true;
}
