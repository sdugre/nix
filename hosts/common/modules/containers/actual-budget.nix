{ config, lib, pkgs, ...}:
let
  dataDir = "/var/lib/containers/actual-budget";
  port = 5006;
#  version = "24.11.0";
in {
  users.users.actualbudget = {
    group = "actualbudget";
    isSystemUser = true;
  };
  users.groups.actualbudget = {};

  # Create folders for the containers
  systemd.tmpfiles.rules = [
    "d ${dataDir}/ 0755 actualbudget actualbudget -"
  ];

  networking.firewall.allowedTCPPorts = [ (lib.toInt (toString port)) ];

  virtualisation.oci-containers.containers.actualbudget = {
    autoStart = true;
    environment = {
      # See all options and more details at
      # https://actualbudget.github.io/docs/Installing/Configuration
      # ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB = 20;
      # ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SYNC_SIZE_LIMIT_MB = 50;
      # ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB = 20;
    };
#    image = "ghcr.io/actualbudget/actual-server:${version}";
    image = "ghcr.io/actualbudget/actual-server:latest";
    ports = ["${toString port}:5006"];
    volumes = ["${dataDir}/:/data"];
  };
}
