{ image = "ghcr.io/hotio/whisparr";

  environment = {
    PUID = "1000";
    PGID = "1000";
    UMASK = "002";
    TZ = "America/New_York";
  };

  volumes = [
    "/var/lib/whisparr:/config"
    "/mnt/music:/data/music"
  ];

  ports = [
    "6969:6969"
  ];

  autoStart = true;

}
