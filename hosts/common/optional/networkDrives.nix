let
  chummieIP = "100.80.19.29";
  mountOptions = [
    "x-gvfs-show"
    "x-systemd.automount"
    "noauto"
  ];
in {
  fileSystems."/mnt/paperless-import" = {
    device = chummieIP + ":/svr/nfs/paperless-import";
    fsType = "nfs";
    options = mountOptions;
  };
  fileSystems."/mnt/media" = {
    device = chummieIP + ":/svr/nfs/media";
    fsType = "nfs";
    options = mountOptions;
  };
  fileSystems."/mnt/files" = {
    device = chummieIP + ":/svr/nfs/files";
    fsType = "nfs";
    options = mountOptions;
  };
  fileSystems."/mnt/photos" = {
    device = chummieIP + ":/svr/nfs/photos";
    fsType = "nfs";
    options = mountOptions;
  };
}
