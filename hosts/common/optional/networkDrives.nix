let
  nasIP = "100.84.193.57";
  chummieIP = "100.80.19.29";
  mountOptions = [
    "x-gvfs-show"
    "x-systemd.automount"
    "noauto"
  ];
in {
  # mount NAS drives via tailscale
  #  fileSystems."/mnt/video" = {
  #    device = nasIP + ":/volume1/video";
  #    fsType = "nfs";
  #    options = mountOptions;
  #  };
  #  fileSystems."/mnt/music" = {
  #    device = nasIP + ":/volume1/music";
  #    fsType = "nfs";
  #    options = mountOptions;
  #  };
  #  fileSystems."/mnt/photo" = {
  #    device = nasIP + ":/volume1/photo";
  #    fsType = "nfs";
  #    options = mountOptions;
  #  };
  #  fileSystems."/mnt/downloads" = {
  #    device = nasIP + ":/volume1/downloads";
  #    fsType = "nfs";
  #    options = mountOptions;
  #  };
  fileSystems."/mnt/homes" = {
    device = nasIP + ":/volume1/homes";
    fsType = "nfs";
    options = mountOptions;
  };
  #  fileSystems."/mnt/docs" = {
  #    device = nasIP + ":/volume1/docs";
  #    fsType = "nfs";
  #    options = mountOptions;
  #  };
  #  fileSystems."/mnt/books" = {
  #    device = nasIP + ":/volume1/books";
  #    fsType = "nfs";
  #    options = mountOptions;
  #  };
  fileSystems."/mnt/podcasts" = {
    device = nasIP + ":/volume1/podcasts";
    fsType = "nfs";
    options = mountOptions;
  };

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
}
