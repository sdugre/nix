{
  lib,
  pkgs,
  config,
  hostname,
  ...
}: let
  port = 8087;
  domain = "rss.seandugre.com";
  authDomain = "auth.seandugre.com";
in {

  sops.secrets."miniflux-creds" = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

  services.miniflux = {
    enable = true;
    config = {
      PORT = toString port;
      BASE_URL = "https://${domain}";
      DISABLE_LOCAL_AUTH = 1;
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_OIDC_PROVIDER_NAME = "Authelia";
      OAUTH2_CLIENT_ID = "miniflux";
      OAUTH2_REDIRECT_URL = "https://${domain}/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://${authDomain}";
      OAUTH2_USER_CREATION = "1";
    };
    # Set initial admin user/password and OAUTH2_CLIENT_SECRET
    adminCredentialsFile = config.sops.secrets."miniflux-creds".path;
  };

  services.authelia.instances.main.settings.identity_providers.oidc.clients = [
    {
      client_id = "miniflux";
      client_secret = "$pbkdf2-sha512$310000$mVbilWssEeKjwcOD8NKmnw$77d5hymwWZM1zBQVXBeeo.2VVKh3mk85ONablJBn3nh1EMtnoG92DIkWE7NiQPGhgS7.wA7mXqAMY.uJxVeU3g";
      authorization_policy = "one_factor";
      redirect_uris = [ 
        "https://${domain}/oauth2/oidc/callback" 
      ];
      consent_mode = "implicit";
    }
  ];

  networking.firewall.allowedTCPPorts = [port];
  networking.firewall.allowedUDPPorts = [port];

  services.rss-bridge = {
    enable = true;
    config.system.enabled_bridges = [
      "Bandcamp"
      "DuckDuckGo"
      "Facebook"
      "Flickr"
      "Twitter"
      "Wikipedia"
      "Youtube"
      "DockerHub"
      "GithubSearchBridge"
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
