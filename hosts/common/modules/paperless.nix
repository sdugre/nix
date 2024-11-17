{
  config,
  lib,
  hostname,
  ...
}: {
  sops.secrets."paperless" = {
    sopsFile = ../../${hostname}/secrets.yaml;
    #   mode = "0400";
    #    owner = "paperless";
    #   group = "paperless";
    #    restartUnits = [ "paperless.service" ];
  };

  services.paperless = {
    enable = true;
    address = "0.0.0.0";
    port = 6382;
    #    mediaDir = "/mnt/docs";
    #    consumptionDir = "/mnt/docs/paperless-inbox";
    consumptionDirIsPublic = true;
    passwordFile = config.sops.secrets.paperless.path;
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
  };

  networking.firewall.allowedTCPPorts = [6382];

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/paperless"
    ];
  };
}
