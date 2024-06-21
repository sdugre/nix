{ image = "haugene/transmission-openvpn:latest";

  environment = {
    PUID = "1000";
    PGID = "1000";
    UMASK = "002";
    TZ = "America/New_York";
    OPENVPN_PROVIDER     = "PIA";
    OPENVPN_CONFIG       = "us_east";
    OPENVPN_USERNAME     = p8409489;
    OPENVPN_PASSWORD     = jsAKmGpEQEUo6R6Cg7zyEcR8;
    LOCAL_NETWORK        = "192.168.0.0/16";
    DISABLE_PORT_UPDATER = "true";
    OPENVPN_OPTS         = "--inactive 3600 --ping 10 --ping-exit 60 --pull-filter ignore ping";
  };

  volumes = [
    "/var/lib/transmission:/config"
    "/mnt/data/torrents:/data/torrents"
  ];

  ports = [
    "9091:9091"
  ];

  autoStart = true;

}
