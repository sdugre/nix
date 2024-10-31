{ config, ... }:{
  services.nginx.virtualHosts."calibre.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:8180";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."/content-server" = {
      return = "301 $scheme://$host/content-server/";
    };
    locations."^~ /content-server/" = {
      proxyPass = "http://192.168.1.200:8181";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
        resolver 127.0.0.11 valid=30s;
      '';
    };

  };
}
