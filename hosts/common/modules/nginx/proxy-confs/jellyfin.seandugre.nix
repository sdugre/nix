{ config, ... }:{
  services.nginx.virtualHosts."jellyfin.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.58:8096";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
        proxy_set_header Range $http_range;
        proxy_set_header If-Range $http_if_range;
      '';
    };
    locations."~ (/jellyfin)?/socket" = {
      proxyPass = "http://192.168.1.58:8096";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
