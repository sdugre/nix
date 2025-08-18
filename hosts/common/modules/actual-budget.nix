{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: let
  port = 5006;
  app = "money";
  domain = "seandugre.com";
  authDomain = "auth.seandugre.com";
in {

  networking.firewall.allowedTCPPorts = [(lib.toInt (toString port))];

  sops.secrets.actual-budget-env = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

  sops.secrets.actual-budget-openid = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

  services.actual = {
    enable = true;
    settings = {
      port = (lib.toInt (toString port));
      loginMethod = "openid";
#      openid = {
#        discoveryURL = authDomain;
#        client_id = "actualbudget";
#        server_hostname = "https://${app}.${domain}";
#        authMethod = "oauth2";
#      };
    };
  };

  systemd.services.actual.serviceConfig.EnvironmentFile = config.sops.secrets.actual-budget-env.path;

  services.authelia.instances.main.settings.identity_providers.oidc.clients = [
    {
      client_id = "actualbudget";
      client_name = "Actual Budget";
      client_secret = "$argon2id$v=19$m=65536,t=3,p=4$DZWyQ9I8Jny6XV1wzVypAA$8OxmeKicxVzJ1nwmQkKju9kWvXTxRDfTewU4vBR1S4c";
      public = false;
      authorization_policy = "one_factor";
      redirect_uris = [
        "https://${app}.${domain}/openid/callback"
      ];
      scopes = [
        "openid"
        "profile"
        "groups"
        "email"
      ];
      userinfo_signed_response_alg = "none";
      token_endpoint_auth_method = "client_secret_basic";
      consent_mode = "implicit";
    }
  ];

  services.nginx.virtualHosts."money.seandugre.com" = {
    useACMEHost = "${domain}";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:5006";
      proxyWebsockets = true;
    };
  };

#  services.meshSidecar = {
#    services = {
#    #  grafana = {
#    #    meshName = "monitoring-grafana";  # Custom hostname on mesh
#    #  };
#      actual = {};
#    };
#  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/private/actual"
    ];
  };
}
