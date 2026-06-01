{
  boot = {
    supportedFilesystems = [
      "nfs"
      "zfs"
      "ntfs"
      "ext4"
    ];
    zfs = {
      forceImportRoot = false;
      unsafeAllowHibernation = true;
    };
  };
}
