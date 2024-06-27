{ 
  image = "lscr.io/linuxserver/readarr:develop";

  environment = {
    PUID                 = "1000";
    PGID                 = "1000";
    UMASK                = "002";
    TZ                   = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/media/readarr:/config"
    "/mnt/data:/data"
  ];

  ports = [
    "8788:8787"
  ];

  autoStart = true;

}
