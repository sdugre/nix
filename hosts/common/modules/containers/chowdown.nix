{ config, pkgs, lib, hostname, ... }:
{ 

  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/chowdown -o root -g root
   '';
  };

  virtualisation.oci-containers.containers = {
    chowdown = {
      image = "gregyankovoy/chowdown:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/chowdown:/config"
      ];
      ports = [
        "4000:4000"
      ];
      autoStart = true;
    };
  };
}
