{ GLUETUN_WG_CREDS }:
{ 
  image = "qmcgaw/gluetun";

  environment = {
    PUID                    = "1000";
    PGID                    = "986";
    UMASK                   = "002";
    TZ                      = "America/New_York";
    VPN_SERVICE_PROVIDER    = "airvpn";
    VPN_TYPE                = "wireguard"; # see below for wireguard environmental file
  };

  environmentFiles = [ GLUETUN_WG_CREDS ];

  extraOptions = [
    "--cap-add=NET_ADMIN"
    "--device=/dev/net/tun:/dev/net/tun:rwm"
  ];
  
  volumes = [
    "/var/lib/containers/media/gluetun:/gluetun"
  ];

  ports = [
    "8283:8283/tcp"
  ];

  autoStart = true;

}
