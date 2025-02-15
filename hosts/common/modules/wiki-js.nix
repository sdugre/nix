{
  config,
  lib,
  pkgs,
  ...
}: let
  port = 5008;
  app = "wiki";
  domain = "seandugre.com";
in {

  systemd.services.wiki-js = {
    requires = [ "postgresql.service" ];
    after    = [ "postgresql.service" ];
  };
  
  services.wiki-js = {
    enable = true;
    settings.db = {
      db  = "wiki-js";
      host = "/run/postgresql";
      type = "postgres";
      user = "wiki-js";
    };
  };
  
  services.postgresql = {
    ensureDatabases = [ "wiki-js" ];
    ensureUsers = [{
      name = "wiki-js";
      ensureDBOwnership = true;
    }];
  };

  services.nginx.virtualHosts."${app}.${domain}" = {
    useACMEHost = "${domain}";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.wiki-js.settings.port}";
      proxyWebsockets = true;
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/private/wiki-js"
    ];
  };
}
