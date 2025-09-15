{
  pkgs,
  config,
  lib,
  hostname,
  ...
}: {
  sops.secrets."paperless" = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

  services.paperless = {
    enable = true;
#    package = pkgs.stable.paperless-ngx;
    address = "0.0.0.0";
    port = 6382;
    consumptionDirIsPublic = true;
    passwordFile = config.sops.secrets.paperless.path;
    domain = "docs.seandugre.com";
    settings = {
      PAPERLESS_ADMIN_USER = "sdugre";
      PAPERLESS_TIME_ZONE = "America/New_York";
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_CONSUMER_POLLING = 60;
      PAPERLESS_URL = "https://docs.seandugre.com";
      PAPERLESS_ENABLE_UPDATE_CHECK = true;
      PAPERLESS_DATE_ORDER = "MDY";
      PAPERLESS_EMAIL_TASK_CRON = "*/5 * * * *";
    };
    exporter = {
      enable = true;
      directory = "/mnt/docs";
      settings = {
        delete = true;
        use-filename-format = true;
        no-archive = true;
        no-thumbnail = true;
        no-progress-bar = true;
      };
    };
  };

  # set permissions so users can browse exported files
  systemd.services.paperless-exporter = {
    serviceConfig = {
      ExecStartPost = ''
        ${pkgs.coreutils}/bin/chmod -R g+r /mnt/docs
        ${pkgs.coreutils}/bin/chgrp -R ${config.services.paperless.user} /mnt/docs
      '';
    };
  };

#  networking.firewall.allowedTCPPorts = [6382];

#  services.authelia.instances.main.settings.identity_providers.oidc = {
#    {
#      client_id = "paperless";
#      client_name = "Paperless";
#      client_secret = "$pbkdf2-...REPLACE";
#      public = false;
#      authorization_policy = "one_factor";
#      redirect_uris = [
#        "https://${config.services.paperless.domain}/accounts/oidc/authelia/login/callback/"
#      ];
#      scopes = [
#        "openid"
#        "profile"
#        "email"
#        "groups"
#      ];
#      userinfo_signed_response_alg = "none";
#      token_endpoint_auth_method = "client_secret_basic";
#    }
#  };

  services.nginx.virtualHosts."docs.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
      client_max_body_size 10M;
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:${toString config.services.paperless.port}";
      proxyWebsockets = true;
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/paperless"
    ];
  };
}
