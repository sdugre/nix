{ config, lib, pkgs, ... }:
{

  imports = [
  #  ./frigate.nix;
  #  ./calibre.nix;
  #  ./calibre-web.nix;
    ./jellyfin.nix;
    ./media.nix;
    ./tube-archivist.nix;
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
    oci-containers.backend = "podman";
  };

# Create folders for the containers
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers -o root -g root
      install -d -m 755 /var/lib/containers/jellyfin -o root -g root
      install -d -m 755 /var/lib/containers/frigate  -o root -g root
      install -d -m 755 /var/lib/containers/media/transmission -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/jackett -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/gluetun -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/lazylibrarian -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/lidarr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/overseerr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/radarr -o sdugre -g media 
      install -d -m 755 /var/lib/containers/media/readarr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/recyclarr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/sonarr -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/tube-archivist -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/qbittorrent -o sdugre -g media
      install -d -m 755 /var/lib/containers/media/whisparr -o sdugre -g media
   '';
  };

  networking.firewall.allowedTCPPorts = [ 51414 ]; # transmission
  networking.firewall.allowedUDPPorts = [ 49688 ]; # gluetun wireguard

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/containers"
    ];
  };
}
