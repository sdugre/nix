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
in {
  users.users.actualbudget = {
    group = "actualbudget";
    isSystemUser = true;
  };
  users.groups.actualbudget = {};

  # Create folders for the containers
  systemd.tmpfiles.rules = [
    "d ${dataDir}/ 0755 actualbudget actualbudget -"
    ''f ${dataDir}/config.json 0644 actualbudget actualbudget - >
      {"openId":{"issuer":"https://${authDomain}","client_id":"actualbudget","client_secret":"insecure_secret","server_hostname":"https://${app}.${domain}","authMethod":"oauth2"}}
    ''
  ];

  networking.firewall.allowedTCPPorts = [(lib.toInt (toString port))];

  sops.secrets.actual-budget-env = {
    sopsFile = ../../../${hostname}/secrets.yaml;
  };

  virtualisation.oci-containers.containers.actualbudget = {
    autoStart = true;
    environment = {
      # See all options and more details at
      # https://actualbudget.github.io/docs/Installing/Configuration
      # ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB = 20;
      # ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SYNC_SIZE_LIMIT_MB = 50;
      # ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB = 20;
#      ACTUAL_OPENID_DISCOVERY_URL = "https:${authDomain}";
#   ACTUAL_OPENID_CLIENT_ID = "actualbudget";
#      ACTUAL_OPENID_SERVER_HOSTNAME = "https://${app}.${domain}";
#      ACTUAL_LOGIN_METHOD = "openid";
#      ACTUAL_TRUSTED_PROXIES = builtins.concatStringsSep "," [ "192.168.1.200" ];
#      ACTUAL_ALLOWED_LOGIN_METHODS = builtins.concatStringsSep "," [ "openid" ];
    };
    environmentFiles = [config.sops.secrets.actual-budget-env.path];
    image = "ghcr.io/actualbudget/actual-server:latest";
    ports = ["${toString port}:5006"];
    volumes = ["${dataDir}/:/data"];
  };

#  services.authelia.instances.main.settings.identity_providers.oidc.clients = [
#    {
#      client_id = "actualbudget";
#      client_secret = "$pbkdf2-sha512$310000$3vkziL8nrZ.YRWHFIDlGXw$AOtK3J0FWFJtVr/Q1bK5Or21MRQEHMp5RvC.7gRpDKhHUDokSFXnn4osJOVWL1kiLatPPqI146iSrFy1LYvzcQ";
#      authorization_policy = "one_factor";
#      redirect_uris = [
#        "https://${app}.${domain}/oauth2/oidc/callback"
#      ];
#      consent_mode = "implicit";
#    }
#  ];

  systemd.services.update-actualbudget = {
    description = "Update Actual Budget container";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman pull ghcr.io/actualbudget/actual-server:latest";
    };
  };

  services.nginx.virtualHosts."money.seandugre.com" = {
    useACMEHost = "${domain}";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:5006";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
