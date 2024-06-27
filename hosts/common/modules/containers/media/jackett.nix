{ 
  image = "lscr.io/linuxserver/jackett";

  environment = {
    PUID                 = "1000";
    PGID                 = "1000";
    UMASK                = "002";
    TZ                   = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/media/jackett:/config"
    "/mnt/data:/data"
  ];

  ports = [
    "9118:9117"
  ];

  autoStart = true;

}
