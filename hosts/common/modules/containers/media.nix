
{ config, pkgs, lib, hostname, ... }:
{
  sops.secrets.gluetun-wg-env = { 
    sopsFile = ../../../${hostname}/secrets.yaml;  
  }; 
# Create folders for the containers
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/media/jackett -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/gluetun -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/lazylibrarian -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/lidarr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/overseerr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/radarr -o sdugre -g media 
      install -d -m 755 /var/lib/containers/media/readarr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/recyclarr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/sonarr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/tube-archivist -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/qbittorrent -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/whisparr -o sdugre -g media
   '';
  };

  networking.firewall.allowedUDPPorts = [ 49688 ]; # gluetun wireguard

  virtualisation.oci-containers.containers = {
    gluetun = {  
      image = "qmcgaw/gluetun";
      environment = {
        PUID                    = "1000";
        PGID                    = "986";
        UMASK                   = "002";
        TZ                      = "America/New_York";
        VPN_SERVICE_PROVIDER    = "airvpn";
        VPN_TYPE                = "wireguard"; # see below for wireguard environmental file
      };
      environmentFiles = [ config.sops.secrets.gluetun-wg-env.path ];
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
    };

    jackett = {
      image = "lscr.io/linuxserver/jackett";
      environment = {
        PUID                 = "1000";
        PGID                 = "986";
        UMASK                = "002";
        TZ                   = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/media/jackett:/config"
        "/mnt/data:/data"
      ];
      ports = [
        "9118:9117"
      ];
      autoStart = true;
    };

    lazylibrarian = {
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
    };

    lidarr = {
      image = "lscr.io/linuxserver/lidarr";
      environment = {
        PUID                 = "1000";
        PGID                 = "986";
        UMASK                = "002";
        TZ                   = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/media/lidarr:/config"
        "/mnt/data:/data"
      ];
      ports = [
        "8687:8686"
      ];
      autoStart = true;      
    };

    overseerr = {
      image = "lscr.io/linuxserver/overseerr:latest";
      environment = {
        PUID                 = "1000";
        PGID                 = "986";
        UMASK                = "002";
        TZ                   = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/media/overseerr:/config"
      ];
      ports = [
        "5056:5055"
      ];
      autoStart = true;
    };

    qbittorrent = {
      image = "lscr.io/linuxserver/qbittorrent";
      environment = {
        PUID            = "1000";
        PGID            = "986";
        UMASK           = "002";
        TZ              = "America/New_York";
        WEBUI_PORT      = "8283";
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
    };

    radarr = {
      image = "lscr.io/linuxserver/radarr";
      environment = {
        PUID                 = "1000";
        PGID                 = "986";
        UMASK                = "002";
        TZ                   = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/media/radarr:/config"
        "/mnt/data:/data"
      ];
      ports = [
        "7879:7878"
      ];
      autoStart = true;
    };

    readarr = {
      image = "lscr.io/linuxserver/readarr:develop";
      environment = {
        PUID                 = "1000";
        PGID                 = "986";
        UMASK                = "002";
        TZ                   = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/media/readarr:/config"
        "/mnt/data:/data"
      ];
      ports = [
        "8788:8787"
      ];
      autoStart = true;
    };

    recyclarr = {
      image = "ghcr.io/recyclarr/recyclarr";
      environment = {
        TZ                      = "America/New_York";
        RECYCLARR_CREATE_CONFIG = "true";
      };
      extraOptions = [
        "--user=1000:986"
      ];
      volumes = [
        "/var/lib/containers/media/recyclarr:/config"
      ];
      ports = [
      ];
      autoStart = true;
    };

    sonarr = {
      image = "lscr.io/linuxserver/sonarr";
      environment = {
        PUID                 = "1000";
        PGID                 = "986";
        UMASK                = "002";
        TZ                   = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/media/sonarr:/config"
        "/mnt/data:/data"
      ];
      ports = [
        "8990:8989"
      ];
      autoStart = true;
    };

    whisparr = {
      image = "ghcr.io/hotio/whisparr";
      environment = {
        PUID = "1000";
        PGID = "986";
        UMASK = "002";
        TZ = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/media/whisparr:/config"
        "/mnt/data:/data"
      ];
      ports = [
        "6969:6969"
      ];
      autoStart = true;
    };
  };
}
