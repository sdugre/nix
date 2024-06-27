{ 
  image = "lscr.io/linuxserver/lidarr";

  environment = {
    PUID                 = "1000";
    PGID                 = "1000";
    UMASK                = "002";
    TZ                   = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/media/lidarr:/config"
    "/mnt/data:/data"
  ];

  ports = [
    "8687:8686"
  ];

  autoStart = true;

}
