{ 
  image = "lscr.io/linuxserver/radarr";

  environment = {
    PUID                 = "1000";
    PGID                 = "1000";
    UMASK                = "002";
    TZ                   = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/media/radarr:/config"
    "/mnt/data:/data"
  ];

  ports = [
    "7879:7878"
  ];

  autoStart = true;

}
