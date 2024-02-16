{ config, lib, hostname,... }:{

  networking.firewall.allowedTCPPorts = [ 4747 ];

  services.gonic = {
    enable = true;
    settings = {
      listen-addr = "0.0.0.0:4747";
      music-path = [ "/mnt/music" ];
      podcast-path = "/mnt/podcasts";
      scan-interval = 720;
      scan-at-start-enabled = true;
      jukebox-enabled = true;
#      exclude-pattern = "/@"; # exclude @eaDir (will only work when nix updates to gonic v16.0)
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/gonic" 
    ];
  };

}
