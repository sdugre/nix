{ 
  image = "lscr.io/linuxserver/sonarr";

  environment = {
    PUID                 = "1000";
    PGID                 = "1000";
    UMASK                = "002";
    TZ                   = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/media/sonarr:/config"
    "/mnt/data:/data"
  ];

  ports = [
    "8990:8989"
  ];

  autoStart = true;

}
