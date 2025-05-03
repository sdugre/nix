{
  config,
  pkgs,
  lib,
  ...
}: {

# NOTE: created zfs dataset and created directory before running container

  virtualisation.oci-containers.containers = {
    photon = {
      image = "rtuszik/photon-docker:latest";
      environment = {
        UPDATE_STRATEGY = "PARALLEL";
        UPDATE_INTERVAL = "24h";
      };
      volumes = [
        "/mnt/geo:/photon/photon_data"
      ];
      ports = [ "2322:2322" ];
      autoStart = true;
    };
  };
  
  networking.firewall.allowedTCPPorts = [2322];
}
