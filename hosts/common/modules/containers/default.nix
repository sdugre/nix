{ config, lib, pkgs, ... }:
{
  imports = [
  #  ./calibre.nix         # can't get to work
  #  ./calibre-web.nix  
    ./chowdown.nix         # recipe wiki
  #  ./frigate.nix         # can't get to work
  #  ./jellyfin.nix
    ./media.nix            # arr stack w/ gluetun for vpn
#    ./tube-archivist.nix  # works, but doesn't auto delete or rename files. Use ytdl-sub instead
    ./ytdl-sub.nix
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "podman";


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
