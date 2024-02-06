{ config, ... }:{
  services.nginx.virtualHosts."books.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.58:8083";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
        proxy_set_header X-Scheme $scheme;
      '';
    };
    locations."/opds/" = {
      proxyPass = "http://192.168.1.58:8083";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
        proxy_set_header X-Scheme $scheme;
      '';
    };
  };
}
