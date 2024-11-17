{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/jellyfin -o root -g root
    '';
  };

  virtualisation.oci-containers.containers = {
    jellyfin = {
      image = "lscr.io/linuxserver/jellyfin:latest";
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/jellyfin:/config"
        "/mnt/data/media:/data"
      ];
      ports = [
        "8096:8096"
        "8920:8920" #optional
        "7359:7359/udp" #optional
        "1902:1900/udp" #optional
      ];
      autoStart = true;
    };
  };
}
