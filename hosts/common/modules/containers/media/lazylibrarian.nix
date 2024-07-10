{ 
  image = "lscr.io/linuxserver/lazylibrarian:latest";

  environment = {
    PUID                 = "1000";
    PGID                 = "986";
    UMASK                = "002";
    TZ                   = "America/New_York";
    DOCKER_MODS = "linuxserver/calibre-web:calibre|linuxserver/mods:lazylibrarian-ffmpeg";
  };

  volumes = [
    "/var/lib/containers/media/lazylibrarian:/config"
    "/mnt/data:/data"
  ];

  ports = [
    "5300:5299"
  ];

  autoStart = true;

}
