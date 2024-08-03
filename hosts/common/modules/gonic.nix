{ config, lib, hostname,... }:{

  # The following needs to be setup manually in the web UI:
  #   - update admin password
  #   - last.fm api key.  See here:  https://www.last.fm/api/accounts

  networking.firewall.allowedTCPPorts = [ 4747 ];

  # relies on overlay to get v0.16.3
  services.gonic = {
    enable = true;
    settings = {
      listen-addr = "0.0.0.0:4747";
      music-path = [ "/mnt/data/media/music" ];
      podcast-path = "/mnt/podcasts";
      playlists-path = "/mnt/data/media/music/_Playlists";
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
    # Fixes conflict with ddclient;  also need to manually chmod /persist/var/lib/private to 700 before rebuild-switch for first setup.
    RuntimeDirectoryMode = 700;
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/private/gonic" 
    ];
  };

}
