
{ config, pkgs, lib, hostname, ... }:
{
  sops.secrets.PIA-env = { 
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
        jellyfin      = import ./containers/jellyfin.nix;
    ### MEDIA POD ###
        transmission  = import ./containers/media/transmission.nix
          { OPENVPN_CREDS = config.sops.secrets.PIA-env.path; };
        jackett       = import ./containers/media/jackett.nix;
        lazylibrarian = import ./containers/media/lazylibrarian.nix;
        lidarr        = import ./containers/media/lidarr.nix;
        overseerr     = import ./containers/media/overseerr.nix;
        radarr        = import ./containers/media/radarr.nix;
        readarr       = import ./containers/media/readarr.nix;
        sonarr        = import ./containers/media/sonarr.nix;
        whisparr      = import ./containers/media/whisparr.nix;

      };
    };
  };

# Create folders for the containers
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers -o root -g root
      install -d -m 755 /var/lib/containers/jellyfin -o root -g root
      install -d -m 755 /var/lib/containers/frigate  -o root -g root
      install -d -m 755 /var/lib/containers/media/transmission -o root -g root
      install -d -m 755 /var/lib/containers/media/jackett -o root -g root
      install -d -m 755 /var/lib/containers/media/lazylibrarian -o root -g root
      install -d -m 755 /var/lib/containers/media/lidarr -o root -g root
      install -d -m 755 /var/lib/containers/media/overseerr -o root -g root
      install -d -m 755 /var/lib/containers/media/radarr -o root -g root 
      install -d -m 755 /var/lib/containers/media/readarr -o root -g root
      install -d -m 755 /var/lib/containers/media/sonarr -o sdugre -g 1000
      install -d -m 755 /var/lib/containers/media/whisparr -o root -g root
   '';
  };

  networking.firewall.allowedTCPPorts = [ 51414 ]; # transmission

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/containers"
    ];
  };

}
