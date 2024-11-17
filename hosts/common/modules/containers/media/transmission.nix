{OPENVPN_CREDS}: {
  image = "haugene/transmission-openvpn:latest";

  environment = {
    PUID = "1000";
    PGID = "986";
    UMASK = "002";
    TZ = "America/New_York";
    OPENVPN_PROVIDER = "PIA";
    OPENVPN_CONFIG = "us_east";
    LOCAL_NETWORK = "192.168.0.0/16";
    DISABLE_PORT_UPDATER = "true";
    OPENVPN_OPTS = "--inactive 3600 --ping 10 --ping-exit 60 --pull-filter ignore ping";
    TRANSMISSION_DOWNLOAD_DIR = "/data/torrents";
    TRANSMISSION_INCOMPLETE_DIR = "/data/torrents/_incomplete";
    TRANSMISSION_INCOMPLETE_DIR_ENABLED = "true";
    TRANSMISSION_WATCH_DIR = "/data/torrents/_watch";
    TRANSMISSION_WATCH_DIR_ENABLED = "true";
  };

  environmentFiles = [OPENVPN_CREDS];

  extraOptions = [
    "--cap-add=NET_ADMIN,mknod"
    "--dns=8.8.8.8"
    "--device=/dev/net/tun:/dev/net/tun:rwm"
  ];

  volumes = [
    "/var/lib/containers/media/transmission:/config"
    "/mnt/data/torrents:/data/torrents"
  ];

  ports = [
    "9092:9091"
  ];

  autoStart = true;
}
