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
#  configFile = pkgs.writeText "actualbudget-config" (builtins.toJSON {
#    openId = {
#      issuer = "https://${authDomain}";
#      client_id = "actualbudget";
#      client_secret = "insecure_secret";
#      server_hostname = "https://${app}.${domain}";
#      authMethod = "oauth2";
#    };
#  });
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
    };
  };

#  services.authelia.instances.main.settings.identity_providers.oidc.clients = [
#    {
#      client_id = "actualbudget";
#      client_name = "Actual Budget";
#      client_secret = "$pbkdf2-sha512$310000$tbIMyiZUeD95zHWcQAtL3w$17AQESE9tywIjQ22DqD8FKx/3G7Yi8DC8QAY5tMltRfsvAxTtmJTcr73/f.b7iFbQfzOLSX.jawko0mqIShVLw";
#      public = false;
#      authorization_policy = "one_factor";
#      redirect_uris = [
#        "https://${app}.${domain}/oauth2/oidc/callback"
#      ];
#      scopes = [
#        "openid"
#        "profile"
#        "groups"
#        "email"
#      ];
#      userinfo_signed_response_alg = "none";
#      token_endpoint_auth_method = "client_secret_basic";
#      consent_mode = "implicit";
#    }
#  ];

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

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/private/actual"
    ];
  };
}
