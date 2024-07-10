{ image = "lscr.io/linuxserver/calibre-web:latest";

  environment = {
    PUID = "1000";
    PGID = "986";
    UMASK = "002";
    TZ = "America/New_York";
    DOCKER_MODS = "linuxserver/mods:universal-calibre"; #optional
    OAUTHLIB_RELAX_TOKEN_SCOPE = "1"; #optional
  };

  volumes = [
    "/var/lib/containers/calibre-web:/config"
    "/mnt/data/media/books:/books"
  ];

  ports = [
    "8083:8083"
  ];

  autoStart = true;

}
