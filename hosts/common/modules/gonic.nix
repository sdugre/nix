{ config, lib, hostname,... }:{

  networking.firewall.allowedTCPPorts = [ 4747 ];

  # relies on overlay to get v0.16.2
  services.gonic = {
    enable = true;
    settings = {
      listen-addr = "0.0.0.0:4747";
      music-path = [ "/mnt/music" ];
      podcast-path = "/mnt/podcasts";
      playlists-path = "/mnt/music/_Playlists";
      cache-path = "/var/cache/gonic";
      scan-interval = 720;
      scan-at-start-enabled = false;
      scan-watcher-enabled = true;
      jukebox-enabled = true;
      exclude-pattern = "/@"; # exclude @eaDir's
      expvar = true;
    };
  };

  systemd.services.gonic.serviceConfig = lib.mkBefore {
    # See https://github.com/sentriz/gonic/issues/391
    Environment = "XDG_CACHE_HOME=/var/cache/gonic/";
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/gonic" 
    ];
  };

}
