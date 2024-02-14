{ self, config, lib, pkgs, hostname, ... }: {


  sops.secrets."nextcloud/admin_password" = {
    sopsFile = ../../${hostname}/secrets.yaml;   
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.seandugre.com";
    # Need to manually increment with every major upgrade.
    package = pkgs.nextcloud28;
    # Let NixOS install and configure the database automatically.
    database.createLocally = true;
    # Let NixOS install and configure Redis caching automatically.
    configureRedis = true;
    # Increase the maximum file upload size.
    maxUploadSize = "16G";
    https = true;
    autoUpdateApps.enable = true;
    extraAppsEnable = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      # List of apps we want to install and are already packaged in
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
      inherit calendar contacts notes onlyoffice tasks cookbook qownnotesapi;
      # Custom app example.
#      socialsharing_telegram = pkgs.fetchNextcloudApp rec {
#        url =
#          "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.0.1/socialsharing_telegram-v3.0.1.tar.gz";
#        license = "agpl3";
#        sha256 = "sha256-8XyOslMmzxmX2QsVzYzIJKNw6rVWJ7uDhU1jaKJ0Q8k=";
#     };
    };
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = config.sops.secrets."nextcloud/admin_password".path;
    };
    settings = {
      overwriteprotocol = "https";
      default_phone_region = "US";
    };
    # Suggested by Nextcloud's health check.
    phpOptions."opcache.interned_strings_buffer" = "16";
  };
    # Nightly database backups.
  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* 01:15:00";
  };
 
  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/nextcloud" 
    ];
  };

}
