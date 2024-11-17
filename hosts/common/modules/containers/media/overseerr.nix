{
  image = "lscr.io/linuxserver/overseerr:latest";

  environment = {
    PUID = "1000";
    PGID = "986";
    UMASK = "002";
    TZ = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/media/overseerr:/config"
  ];

  ports = [
    "5056:5055"
  ];

  autoStart = true;
}
