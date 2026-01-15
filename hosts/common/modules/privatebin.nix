{
  config,
  pkgs,
  lib,
  ...
}: let
  domain = "seandugre.com";
in {

  services.privatebin = {
    enable = true;
    enableNginx = true;
    virtualHost = "paste.${domain}";
    settings = {
      main = {
        sizelimit = 52428800; # 50MiB
        fileupload = true;
      };
      traffic = {
        limit = 60; # seconds
      };
    };
  };

  # extra nginx config to make it work
  services.nginx.virtualHosts.${config.services.privatebin.virtualHost} = {
    useACMEHost = "${domain}";
    forceSSL = true;
    locations = {
      # For Cloudflare compatibility
      "~ \\.js$" = {
        extraConfig = ''
          add_header Cache-Control "public, max-age=3600, must-revalidate, no-transform";
          try_files $uri $uri/ =404;
        '';
      };
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "${config.services.privatebin.dataDir}"
    ];
  };
}
