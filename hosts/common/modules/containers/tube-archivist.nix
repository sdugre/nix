{ config, pkgs, lib, hostname, ... }:
let
  TUBEARCHIVIST_CREDS = config.sops.secrets.tube-archivist-env.path;
  TUBEARCHIVIST_ELASTIC_CREDS = config.sops.secrets.tube-archivist-elastic-env.path;
in
{
  sops.secrets."tube-archivist-env" = { 
    sopsFile = ../../../${hostname}/secrets.yaml; 
  };

  sops.secrets."tube-archivist-elastic-env" = { 
    sopsFile = ../../../${hostname}/secrets.yaml; 
  };

  networking.firewall.allowedTCPPorts = [ 8050 ];

  # we create a systemd service so that we can create a single "pod"
  # for our containers to live inside of. This will mimic how docker compose
  # creates one network for the containers to live inside of
#  systemd.services.create-tube-archivist-network = with config.virtualisation.oci-containers; {
  systemd.services.create-tube-archivist-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [ 
      "${backend}-tube-archivist-app.service"
      "${backend}-tube-archivist-es.service" 
      "${backend}-tube-archivist-redis.service" 
    ];
    script = ''
#      ${pkgs.podman}/bin/podman network exists ta-net || \
#      ${pkgs.podman}/bin/podman network create ta-net
      ${pkgs.podman}/bin/podman pod exists tube-archivist || \
      ${pkgs.podman}/bin/podman pod create -n tube-archivist -p '0.0.0.0:8050:8000'

     '';
  };

# Create folders for the containers
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/tube-archivist -o sdugre -g media
      install -d -m 755 /var/lib/containers/tube-archivist/cache -o sdugre -g media
      install -d -m 755 /var/lib/containers/tube-archivist/es -o sdugre -g media
      install -d -m 755 /var/lib/containers/tube-archivist/redis -o sdugre -g media
   '';
  };

  virtualisation.oci-containers.containers = {
    tube-archivist-app = {  
      image = "docker.io/bbilly1/tubearchivist";
      environment = {
          UMASK                = "002";
          TZ                   = "America/New_York";
          ES_URL               = "http://tube-archivist-es:9200";          # needs protocol e.g. http and port
          REDIS_HOST           = "tube-archivist-redis";                 # don't add protocol
          HOST_UID             = "1000";
          HOST_GID             = "986";
          TA_HOST              = "192.168.1.200";          # set your host name
      };
      environmentFiles = [ 
        TUBEARCHIVIST_CREDS 
        TUBEARCHIVIST_ELASTIC_CREDS
      ];
      volumes = [
        "/var/lib/containers/tube-archivist/cache:/cache"
        "/mnt/data/media/videos-youtube:/youtube"
      ];
#      ports = [
#        "8050:8000"
#      ];
      dependsOn = [
        "tube-archivist-es"
        "tube-archivist-redis"
      ];
      extraOptions = [
        "--pod=tube-archivist"
      ];
      autoStart = true;
    };

    tube-archivist-es = {
      image = "docker.io/bbilly1/tubearchivist-es";
      environment = {
          UMASK                    = "002";
          TZ                       = "America/New_York";
          ES_JAVA_OPTS             = "-Xms1g -Xmx1g";
          "xpack.security.enabled" = "true";
          "discovery.type"         = "single-node";
          "path.repo"              = "/usr/share/elasticsearch/data/snapshot";
      };
      environmentFiles = [ TUBEARCHIVIST_ELASTIC_CREDS ];
      volumes = [
          "/var/lib/containers/tube-archivist/es:/usr/share/elasticsearch/data"
      ];
 #     ports = [
 #        "9200:9200"
 #     ];
      extraOptions = [
        "--pod=tube-archivist"
        "--ulimit=memlock=-1:-1"
      ];
      autoStart = true;
    };

    tube-archivist-redis = {
      image = "docker.io/redis/redis-stack-server";
      environment = {
        UMASK                = "002";
        TZ                   = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/tube-archivist/redis:/data"
      ];
#      ports = [
#        "6379:6379"
#      ];
      extraOptions = [
        "--pod=tube-archivist"
      ];
      dependsOn = [
        "tube-archivist-es"
      ];
      autoStart = true;
    };
  };
}
