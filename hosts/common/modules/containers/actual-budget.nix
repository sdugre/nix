{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: let
  dataDir = "/var/lib/containers/actual-budget";
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
#  users.users.actualbudget = {
#    group = "actualbudget";
#    isSystemUser = true;
#  };
#  users.groups.actualbudget = {};

  # Create folders for the containers
#  systemd.tmpfiles.rules = [
#    "d ${dataDir}/ 0755 actualbudget actualbudget -"
    #"f ${dataDir}/config.json 0644 actualbudget actualbudget - ${pkgs.writeText "actualbudget-config" (builtins.readFile config.sops.secrets.actual-budget-config.path)}"
    #"f ${dataDir}/config.json 0644 actualbudget actualbudget - ${pkgs.writeText "actualbudget-config" (builtins.readFile config.sops.templates.actual-budget-config-template.path)}"
#  ];

  networking.firewall.allowedTCPPorts = [(lib.toInt (toString port))];

  sops.secrets.actual-budget-env = {
    sopsFile = ../../../${hostname}/secrets.yaml;
  };

  sops.secrets.actual-budget-openid = {
    sopsFile = ../../../${hostname}/secrets.yaml;
  };

#  virtualisation.oci-containers.containers.actualbudget = {
#    autoStart = true;
#    environment = {
#      # See all options and more details at
#      # https://actualbudget.github.io/docs/Installing/Configuration
#      # ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB = 20;
#      # ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SYNC_SIZE_LIMIT_MB = 50;
#      # ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB = 20;
#    };
#    environmentFiles = [config.sops.secrets.actual-budget-env.path];
#    image = "ghcr.io/actualbudget/actual-server:latest";
#    ports = ["${toString port}:5006"];{
#    volumes = ["${dataDir}/:/data"];
#  };

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

#  systemd.services.update-actualbudget = {
#    description = "Update Actual Budget container";
#    serviceConfig = {
#      Type = "oneshot";
#      ExecStart = "${pkgs.podman}/bin/podman pull ghcr.io/actualbudget/actual-server:latest";
#    };
#  };

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
}
