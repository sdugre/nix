{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {

  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/fossflow -o root -g root
      install -d -m 755 /var/lib/containers/fossflow/diagrams -o root -g root
    '';
  };

  virtualisation.oci-containers.containers = {
    fossflow = {
      image = "stnsmith/fossflow:latest";
      environment = {
        TZ = "America/New_York";
        JELU_METADATA_CALIBRE_PATH = "/usr/bin/fetch-ebook-metadata";
        NODE_ENV = "production";
        STORAGE_PATH = "/data/diagrams";
      };
      volumes = [
        "/var/lib/containers/fossflow/diagrams:/data/diagrams"
      ];
      ports = [
        "6767:80"
      ];
      autoStart = true;
    };
  };
  
  networking.firewall.allowedTCPPorts = [6767];

  services.nginx.virtualHosts."diag.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:6767";
      proxyWebsockets = true;
    };
  };
}
