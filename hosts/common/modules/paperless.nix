{ config, lib, hostname,... }:{

  sops.secrets."paperless" = { 
    sopsFile = ../../${hostname}/secrets.yaml;   
 #   mode = "0400";
#    owner = "paperless";
 #   group = "paperless";
#    restartUnits = [ "paperless.service" ];
  };

  services.paperless = {
    enable = true;
    mediaDir = "/mnt/docs";
    consumptionDir = "/mnt/docs/paperless-inbox";
#    consumptionDirlsPublic = true;
#    passwordFile = config.sops.secrets.paperless.path;
    settings = {
 #     PAPERLESS_ADMIN_USER 		= "sdugre";
      PAPERLESS_TIME_ZONE 		= "America/New_York";
      PAPERLESS_OCR_LANGUAGE 		= "eng";
      PAPERLESS_CONSUMER_POLLING 	= 60;
      PAPERLESS_URL 			= "https://docs.seandugre.com";
      PAPERLESS_ENABLE_UPDATE_CHECK 	= true;
      PAPERLESS_DATE_ORDER 		= "MDY";
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/paperless" 
    ];
  };

}
