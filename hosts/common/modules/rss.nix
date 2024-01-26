{ lib, pkgs, config, ... }:
let 
  port = 8087;
  domain = "rss.seandugre.com";
in
{  

  services.miniflux = {
    enable = true;
    config = {
      PORT = toString port;
    };
    # Set initial admin user/password
    adminCredentialsFile = pkgs.writeText "cred" ''
      ADMIN_USERNAME=miniflux
      ADMIN_PASSWORD=miniflux
    '';
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
    #virtualHost = "${domain}";
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ "/var/lib/postgresql" ];
  };

}

