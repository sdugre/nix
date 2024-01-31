{ config, ... }:{
  services.nginx.virtualHosts."rsss.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
#    enableAuthelia = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.miniflux.config.PORT}";
      proxyWebsockets = true;
    };
  };
}