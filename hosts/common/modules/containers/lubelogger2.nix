{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: let
  TUBEARCHIVIST_CREDS = config.sops.secrets.tube-archivist-env.path;
  TUBEARCHIVIST_ELASTIC_CREDS = config.sops.secrets.tube-archivist-elastic-env.path;
in {
  sops.secrets."tube-archivist-env" = {
    sopsFile = ../../../${hostname}/secrets.yaml;
  };

  sops.secrets."tube-archivist-elastic-env" = {
    sopsFile = ../../../${hostname}/secrets.yaml;
  };

  networking.firewall.allowedTCPPorts = [8999];

  # we create a systemd service so that we can create a single "pod"
  # for our containers to live inside of. This will mimic how docker compose
  # creates one network for the containers to live inside of
  #  systemd.services.create-tube-archivist-network = with config.virtualisation.oci-containers; {
  systemd.services.create-lubelogger-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [
      "${backend}-lubelogger.service"
      "${backend}-lubelogger-db.service"
    ];
    script = ''
            ${pkgs.podman}/bin/podman pod exists lubelogger || \
            ${pkgs.podman}/bin/podman pod create -n lubelogger -p '0.0.0.0:8999:8080'

    '';
  };

  # Create folders for the containers
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/lubelogger -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/config -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/data -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/translations -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/documents -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/images -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/temp -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/log -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/keys -o sdugre -g users
      install -d -m 755 /var/lib/containers/lubelogger/postgres -o sdugre -g users
    '';
  };

  virtualisation.oci-containers.containers = {
    tube-archivist-app = {
      image = "ghcr.io/hargata/lubelogger:latest"
      environment = {
        UMASK = "002";
        TZ = "America/New_York";
	LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
        LOGGING__LOGLEVEL__DEFAULT = "Error";
      };
      environmentFiles = [
        TUBEARCHIVIST_CREDS
        TUBEARCHIVIST_ELASTIC_CREDS
      ];
      volumes = [
        "/var/lib/containers/lubelogger/config:/App/config"
        "/var/lib/containers/lubelogger/data:/App/data"
        "/var/lib/containers/lubelogger/translations:/App/wwwroot/translations"
        "/var/lib/containers/lubelogger/documents:/App/wwwroot/documents"
        "/var/lib/containers/lubelogger/images:/App/wwwroot/images"
        "/var/lib/containers/lubelogger/temp:/App/wwwroot/temp"
        "/var/lib/containers/lubelogger/log:/App/log"
        "/var/lib/containers/lubelogger/keys:/root/.aspnet/DataProtection-Keys"
      ];
      #      ports = [
      #        "8999:8080"
      #      ];
      dependsOn = [
        "lubelogger-db"
      ];
      extraOptions = [
        "--pod=lubelogger"
      ];
      autoStart = true;
    };

    lubelogger-db = {
      image = "postgres:14";
      environment = {
        UMASK = "002";
        TZ = "America/New_York";
      };
      environmentFiles = [ LUBELOGGER-DB_CREDS ];
      volumes = [
        "/var/lib/containers/lubelogger/postgres:/var/lib/postgresql/data"
	"/etc/localtime:/etc/localtime:ro"

      ];
      #     ports = [
      #        "9200:9200"
      #     ];
      extraOptions = [
        "--pod=lubelogger"
      ];
      autoStart = true;
    };

  postgres:
    image: postgres:14
    restart: unless-stopped
    environment:
      POSTGRES_USER: "lubelogger"
      POSTGRES_PASSWORD: "lubepass"
      POSTGRES_DB: "lubelogger"
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - postgres:/var/lib/postgresql/data
      - /etc/localtime:/etc/localtime:ro

}
