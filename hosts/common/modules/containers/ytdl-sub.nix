{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/ytdl-sub -o sdugre -g media
    '';
  };

  virtualisation.oci-containers.containers = {
    ytdl-sub = {
      image = "ghcr.io/jmbannon/ytdl-sub:latest";
      ports = [
        "8443:8443"
      ];
      volumes = [
        "/var/lib/containers/ytdl-sub:/config"
        "/mnt/data/media/videos-youtube:/youtube"
        "/mnt/data/media/videos-music:/music-videos"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
        DOCKER_MODS = "linuxserver/mods:universal-cron";
      };
      autoStart = true;
    };
  };
}
