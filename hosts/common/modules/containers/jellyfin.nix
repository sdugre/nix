{ image = "lscr.io/linuxserver/jellyfin:latest";

  environment = {
    PUID = "1000";
    PGID = "1000";
    TZ = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/jellyfin:/config"
    "/mnt/video/TV:/data/tvshows"
    "/mnt/video/Movies:/data/movies"
    "/mnt/music:/data/music"
  ];

  ports = [
    "8096:8096"
    "8920:8920"     #optional
    "7359:7359/udp" #optional
    "1902:1900/udp" #optional
  ];

  autoStart = true;

}
