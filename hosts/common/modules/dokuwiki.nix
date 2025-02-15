{
  config,
  lib,
  pkgs,
  ...
}: let
  port = 5007;
  app = "wiki";
  domain = "seandugre.com";
in {

  services.dokuwiki.sites."wiki" = {
    enable = true;
    settings.title = "Home Wiki";
    settings.useacl = false;
    settings.baseurl = "http://192.168.1.200:5007";
  };

#  services.nginx.virtualHosts."wiki" = {
#    useACMEHost = "${domain}";
#    forceSSL = true;
#    enableAuthelia = false;
#    extraConfig = ''
#    '';
#    locations."/" = {
#      proxyPass = "http://192.168.1.200:5007";
#      proxyWebsockets = true;
#    };
#  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/dokuwiki"
    ];
  };
}
