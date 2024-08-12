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
   '';
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/containers"
    ];
  };
}
