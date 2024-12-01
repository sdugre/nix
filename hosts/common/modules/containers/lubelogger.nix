{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: let
  LUBELOGGER-DB_CREDS = config.sops.secrets.lubelogger-db-env.path;
  basePath = "/var/lib/containers/lubelogger";
  port = 8999;
  initSql = pkgs.fetchFromGitHub {
    owner = "hargata";
    repo = "lubelog";
    rev = "main";  # or specific commit hash
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # replace with actual hash
  } + "/init.sql";
in {
  sops.secrets."lubelogger-db-env" = {
    sopsFile = ../../../${hostname}/secrets.yaml;
  };

  networking.firewall.allowedTCPPorts = [ ${port} ];

  # we create a systemd service so that we can create a single "pod"
  # for our containers to live inside of. This will mimic how docker compose
  # creates one network for the containers to live inside of
  systemd.services.create-lubelogger-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    description = "Create Lubelogger Podman pod";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    # wantedBy = [
    #  "${backend}-lubelogger.service"
    #  "${backend}-lubelogger-db.service"
    #];
    script = ''
      ${pkgs.podman}/bin/podman pod exists lubelogger || \
      ${pkgs.podman}/bin/podman pod create -n lubelogger -p '0.0.0.0:${port}:8080'
    '';
  };

  # Create folders for the containers
  systemd.tmpfiles.rules = [
    "d ${basePath} 0755 root root -"
    "d ${basePath}/config 0755 root root -"
    "d ${basePath}/data 0755 root root -"
    "d ${basePath}/translations 0755 root root -"
    "d ${basePath}/documents 0755 root root -"
    "d ${basePath}/images 0755 root root -"
    "d ${basePath}/temp 0755 root root -"
    "d ${basePath}/log 0755 root root -"
    "d ${basePath}/keys 0755 root root -"
    "d ${basePath}/postgres 0755 root root -"
  ];

  virtualisation.oci-containers.containers = {
    lubelogger-app = {
      image = "ghcr.io/hargata/lubelogger:latest"
      environment = {
	LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
        LOGGING__LOGLEVEL__DEFAULT = "Error";
      };
      environmentFiles = [
      ];
      volumes = [
        "${basePath}/config:/App/config"
        "${basePath}/data:/App/data"
        "${basePath}/translations:/App/wwwroot/translations"
        "${basePath}/documents:/App/wwwroot/documents"
        "${basePath}/images:/App/wwwroot/images"
        "${basePath}/temp:/App/wwwroot/temp"
        "${basePath}/log:/App/log"
        "${basePath}/keys:/root/.aspnet/DataProtection-Keys"
      ];
      dependsOn = [
        "lubelogger-postgres"
      ];
      extraOptions = [
        "--pod=lubelogger"
      ];
      autoStart = true;
    };

    lubelogger-postgres = {
      image = "postgres:14";
      environment = {
      };
      environmentFiles = [ LUBELOGGER-DB_CREDS ];
      volumes = [
        "/var/lib/containers/lubelogger/postgres:/var/lib/postgresql/data"
	"/etc/localtime:/etc/localtime:ro"
        "${initSql}:/docker-entrypoint-initdb.d/init.sql"
      ];
      extraOptions = [
        "--pod=lubelogger"
      ];
      autoStart = true;
    };
  };
}
