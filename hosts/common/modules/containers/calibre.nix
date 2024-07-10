{ image = "lscr.io/linuxserver/calibre:latest";

  environment = {
    PUID = "1000";
    PGID = "986";
    UMASK = "002";
    TZ = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/calibre:/config"
    "/mnt/data/media/books:/books"
  ];

  ports = [
    "8080:8080"
    "8081:8081"
  ];

  autoStart = true;

}
