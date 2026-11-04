{
  boot = {
    supportedFilesystems = [
      "nfs"
      "zfs"
      "ntfs"
      "ext4"
      "exfat"
    ];
    zfs = {
      forceImportRoot = false;
      unsafeAllowHibernation = true;
    };
  };
}
