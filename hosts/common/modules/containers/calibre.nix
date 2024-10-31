{ 

# Create folders for the containers
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/calibre -o sdugre -g media
   '';
  };

  networking.firewall.allowedTCPPorts = [ 8180 8181 ];

  virtualisation.oci-containers.containers = {
    calibre = { 

      image = "lscr.io/linuxserver/calibre:latest";

      environment = {
        PUID = "1000";
        PGID = "986";
        UMASK = "002";
        TZ = "America/New_York";
      };

      volumes = [
        "/var/lib/calibre-lib:/config"
        "/mnt/data/media/books:/books"
      ];

      ports = [
        "8180:8080"
        "8181:8081"
      ];

      autoStart = true;
    };
  };
}
