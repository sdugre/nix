{ lib, config, ... }:
{
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/plex" 
    ];
  };

}
