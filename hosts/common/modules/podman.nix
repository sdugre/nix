{ config, lib, hostname, ... }:{

  sops.secrets."PIA" = { 
    sopsFile = ../../${hostname}/secrets.yaml;  

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
#        frigate  = import ./containers/frigate.nix;
        jellyfin = import ./containers/jellyfin.nix;
    ### MEDIA POD ###
        whisparr = import ./containers/media/whisparr.nix;
      };
    };
  };

# Create folders for the containers
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/jellyfin -o root -g root
      install -d -m 755 /var/lib/frigate  -o root -g root
      install -d -m 755 /var/lib/media/whisparr -o root -g root
      install -d -m 755 /var/lib/media/transmission -o root -g root
    '';
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/containers"
      "/var/lib/jellyfin"
      "/var/lib/media"
    ];
  };


}
