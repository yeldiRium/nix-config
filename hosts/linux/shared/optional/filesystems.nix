{
  boot = {
    supportedFilesystems = [
      "nfs"
      "zfs"
      "ntfs"
      "ext4"
      "exfat"
      "vfat"
    ];
    zfs = {
      forceImportRoot = false;
      unsafeAllowHibernation = true;
    };
  };
}
