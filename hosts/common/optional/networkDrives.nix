  let 
    nasIP = "100.84.193.57";
    mountOptions = [
      "x-gvfs-show"
      "x-systemd.automount" 
      "noauto"
    ];
  in
{
  # mount NAS drives via tailscale
  fileSystems."/mnt/video" = {
    device = nasIP + ":/volume1/video";
    fsType = "nfs";
    options = mountOptions;
  };
  fileSystems."/mnt/music" = {
    device = "100.84.193.57:/volume1/music";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/photo" = {
    device = "100.84.193.57:/volume1/photo";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/downloads" = {
    device = "100.84.193.57:/volume1/downloads";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  };
  fileSystems."/mnt/homes" = {
    device = "100.84.193.57:/volume1/homes";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/docs" = {
    device = "100.84.193.57:/volume1/docs";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
}
