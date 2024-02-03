{ lib, pkgs, config, hostname, ... }:
let 
  port = 8087;
  domain = "rss.seandugre.com";
in
{  

  sops.secrets."miniflux-creds" = { 
    sopsFile = ../../${hostname}/secrets.yaml; 
  };

  services.miniflux = {
    enable = true;
    config = {
      PORT = toString port;
    };
    # Set initial admin user/password
    adminCredentialsFile = config.sops.secrets."miniflux-creds".path;
  };

  networking.firewall.allowedTCPPorts = [ port ];
  networking.firewall.allowedUDPPorts = [ port ];

  services.rss-bridge = {
    enable = true;
    whitelist = [ 
      "Bandcamp"
      "DuckDuckGo"
      "Facebook"
      "Flickr"
      "Twitter"
      "Wikipedia"
      "Youtube"
      "DockerHub"
    ];
    virtualHost = "rss-bridge.seandugre.com";
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/postgresql" 
      "/var/lib/rss-bridge"
    ];
  };

}

