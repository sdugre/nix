{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: let
  basePath = "/var/lib/containers/dawarich";
in {
  sops.secrets."dawarich.env" = {
    sopsFile = ../../../${hostname}/secrets.yaml;
  };

  networking.firewall.allowedTCPPorts = [ 3070 ];

  # we create a systemd service so that we can create a single "pod"
  # for our containers to live inside of. This will mimic how docker compose
  # creates one network for the containers to live inside of
  # systemd.services.create-tube-archivist-network = with config.virtualisation.oci-containers; {
  systemd.services.create-dawarich-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [
      "${backend}-dawarich.service"
      "${backend}-dawarich-db.service"
    ];
    script = ''
            ${pkgs.podman}/bin/podman pod exists dawarich || \
            ${pkgs.podman}/bin/podman pod create -n dawarich -p '0.0.0.0:3070:3000'
    '';
  };

  # Create folders for the containers
  systemd.tmpfiles.rules = [
    "d ${basePath} 0755 root root -"
    "d ${basePath}/shared 0755 root root -"
    "d ${basePath}/db_data 0755 root root -"
    "d ${basePath}/public 0755 root root -"
    "d ${basePath}/watched 0755 root root -"
    "d ${basePath}/storage 0755 root root -"
  ];

  virtualisation.oci-containers.containers = {
    dawarich_db = {
      image = "postgis/postgis:17-3.5-alpine";
      volumes = [
        "${basePath}/db_data:/var/lib/postgresql/data"
        "${basePath}/shared:/var/shared"
      ];
      environmentFiles = [
        config.sops.secrets."dawarich.env".path
      ];
      autoStart = true;
      log-driver = "journald";
      extraOptions = [
        "--pod=dawarich"
        "--health-cmd=pg_isready -U postgres -d dawarich_development"
        "--health-interval=10s"
        "--health-retries=5"
        "--health-start-period=30s"
        "--health-timeout=10s"
        "--shm-size=1073741824"
      ];
    };

    dawarich = {
      image = "freikin/dawarich:latest";
      volumes = [
        "${basePath}/public:/var/app/public"
        "${basePath}/watched:/var/app/tmp/imports/watched"
        "${basePath}/storage:/var/app/storage"
        "${basePath}/db_data:/dawarich_db_data"
      ];
      environmentFiles = [
        config.sops.secrets."dawarich.env".path
      ];
      cmd = [ "bin/rails" "server" "-p" "3000" "-b" "0.0.0.0" ];
      autoStart = true; 
      environment = {
        "APPLICATION_HOSTS" = "loc.seandugre.com,localhost";
        "APPLICATION_PROTOCOL" = "http";
        "DATABASE_HOST" = "dawarich_db";
        "DATABASE_NAME" = "dawarich_development";
        "DISABLE_HOST_AUTHORIZATION" = "true";
        "DISTANCE_UNIT" = "mi";
        "ENABLE_TELEMETRY" = "false";
        "MIN_MINUTES_SPENT_IN_CITY" = "60";
        "PROMETHEUS_EXPORTER_ENABLED" = "false";
        "PROMETHEUS_EXPORTER_HOST" = "0.0.0.0";
        "PROMETHEUS_EXPORTER_PORT" = "9394";
        "RAILS_ENV" = "development";
        "TIME_ZONE" = "America/Toronto";
        "PHOTON_API_HOST" = "192.168.1.200:2322";
        "PHOTON_API_USE_HTTPS" = "false";
        "SELF_HOSTED" = "true";
        "QUEUE_DATABASE_PATH" = "/dawarich_db_data/dawarich_development_queue.sqlite3";
        "CACHE_DATABASE_PATH" = "/dawarich_db_data/dawarich_development_cache.sqlite3";
        "CABLE_DATABASE_PATH" = "/dawarich_db_data/dawarich_development_cable.sqlite3";
      };
      extraOptions = [
        "--pod=dawarich"
        "--entrypoint=web-entrypoint.sh"
        "--health-cmd=wget -qO - http://127.0.0.1:3000/api/v1/health | grep -q '\"status\"\\s*:\\s*\"ok\"'"
        "--health-interval=10s"
        "--health-retries=30"
        "--health-start-period=30s"
        "--health-timeout=10s"
      ];
      log-driver = "journald";
      dependsOn = [
        "dawarich_db"
      ];
    };
  };
}
