{ config, ... }:{
  services.nginx.virtualHosts."readarr.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:8788";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."~ (/readarr)?/api" = {
      proxyPass = "http://192.168.1.200:8788";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
