{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {

  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/owntone -o root -g root
      install -d -m 755 /var/lib/containers/owntone/etc -o root -g root
      install -d -m 755 /var/lib/containers/owntone/cache -o root -g root
    '';
  };

  virtualisation.oci-containers.containers = {
    owntone = {
      image = "docker.io/owntone/owntone:latest";
      environment = {
        TZ = "America/New_York";
#        PUID = "1000";
#        PGID = "1000";
      };
      volumes = [
        "/var/lib/containers/owntone/etc:/etc/owntone"
        "/var/lib/containers/owntone/cache:/var/cache/owntone"
        "/mnt/data/media/music:/svr/media"
      ];
      ports = [ 
        "3689:3689"
        "3688:3688"
      ];
      autoStart = true;
    };
  };
  
  networking.firewall.allowedTCPPorts = [];

  services.nginx.virtualHosts."owntone.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:3689";
      proxyWebsockets = true;
    };
  };
}

