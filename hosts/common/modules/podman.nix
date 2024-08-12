
{ config, pkgs, lib, hostname, ... }:
{
  sops.secrets.gluetun-wg-env = { 
    sopsFile = ../../${hostname}/secrets.yaml;  
  }; 

  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true; # release 23.05
      # defaultNetwork.dnsname.enable = true; # use with older releases
    };

    oci-containers = {
      backend = "podman";

      containers = {
#        frigate       = import ./containers/frigate.nix;
#        calibre       = import ./containers/calibre.nix;
#        calibre-web   = import ./containers/calibre-web.nix;
        jellyfin      = import ./containers/jellyfin.nix;
    ### MEDIA POD ###
#        transmission  = import ./containers/media/transmission.nix
#          { OPENVPN_CREDS = config.sops.secrets.PIA-env.path; };     # removed - using qbittorrent now
        gluetun        = import ./containers/media/gluetun.nix
          { GLUETUN_WG_CREDS = config.sops.secrets.gluetun-wg-env.path; };
        jackett        = import ./containers/media/jackett.nix;
        lazylibrarian  = import ./containers/media/lazylibrarian.nix;
        lidarr         = import ./containers/media/lidarr.nix;
        overseerr      = import ./containers/media/overseerr.nix;
        radarr         = import ./containers/media/radarr.nix;
        readarr        = import ./containers/media/readarr.nix;
        recyclarr      = import ./containers/media/recyclarr.nix;  
        sonarr         = import ./containers/media/sonarr.nix;
        tube-archivist = import ./containers/media/tube-archivist
          { inherit config pkgs hostname; };
        qbittorrent    = import ./containers/media/qbittorrent.nix;
        whisparr       = import ./containers/media/whisparr.nix;
      };
    };
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
