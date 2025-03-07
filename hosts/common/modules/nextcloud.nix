{
  self,
  config,
  lib,
  pkgs,
  hostname,
  ...
}: {
  # enable writing to external storage
  users.users.nextcloud.extraGroups = [ "users" ];

  sops.secrets."nextcloud/admin_password" = {
    sopsFile = ../../${hostname}/secrets.yaml;
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.seandugre.com";
    # Need to manually increment with every major upgrade.
    package = pkgs.nextcloud31;
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
      #      inherit calendar contacts notes onlyoffice tasks cookbook qownnotesapi;
      inherit calendar contacts tasks onlyoffice;
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

#  WAITING FOR https://github.com/NixOS/nixpkgs/issues/383483 TO BE RESOLVED
#  REF:  https://diogotc.com/blog/collabora-nextcloud-nixos/
#  services.collabora-online = {
#    enable = true;
#    port = 9980; # default
#    settings = {
#      # Rely on reverse proxy for SSL
#      ssl = {
#        enable = false;
#        termination = true;
#      };
#
#      # Listen on loopback interface only, and accept requests from ::1
#      net = {
#        listen = "loopback";
#        post_allow.host = ["::1"];
#      };
#
#      # Restrict loading documents from WOPI Host nextcloud.example.com
#      storage.wopi = {
#        "@allow" = true;
#        host = ["cloud.seandugre.com"];
#      };
#
#      # Set FQDN of server
#      server_name = "office.seandugre.com";
#    };
#  };
  
  services.nginx.virtualHosts."cloud.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    # the rest handled by the module
    # locations."/" = {
    #   proxyPass = "https://192.168.58:4043";
    #   proxyWebsockets = true;
    #   extraConfig = ''
    #     resolver 127.0.0.11 valid=30s;
    #     proxy_max_temp_file_size 2048m;
    #   '';
    # };
  };
#    
#  services.nginx.virtualHosts."office.seandugre.com" =  {
#    enableACME = true;
#    forceSSL = true;
#    locations."/" = {
#      proxyPass = "http://[::1]:${toString config.services.collabora-online.port}";
#      proxyWebsockets = true; # collabora uses websockets
#    };
#  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/nextcloud"
    ];
  };
}
