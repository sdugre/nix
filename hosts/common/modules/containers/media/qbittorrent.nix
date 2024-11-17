{
  image = "lscr.io/linuxserver/qbittorrent";

  environment = {
    PUID = "1000";
    PGID = "986";
    UMASK = "002";
    TZ = "America/New_York";
    WEBUI_PORT = "8283";
    TORRENTING_PORT = "6881";
  };

  volumes = [
    "/var/lib/containers/media/qbittorrent:/config"
    "/mnt/data/torrents:/data/torrents"
  ];

  ports = [
    "8283:8283"
    "6881:6881"
    "6881:6881/udp"
  ];

  dependsOn = ["gluetun"];
  extraOptions = ["--network=container:gluetun"];

  autoStart = true;
}
