{

  fileSystems."/mnt/video" = {
    device = "192.168.1.16:/volume1/video";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  };
  fileSystems."/mnt/music" = {
    device = "192.168.1.16:/volume1/music";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/photo" = {
    device = "192.168.1.16:/volume1/photo";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/downloads" = {
    device = "192.168.1.16:/volume1/downloads";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  };
  fileSystems."/mnt/homes" = {
    device = "192.168.1.16:/volume1/homes";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 
  fileSystems."/mnt/docs" = {
    device = "192.168.1.16:/volume1/docs";
    fsType = "nfs";
    options = ["x-gvfs-show"];
  }; 

}
