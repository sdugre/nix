{ config, ... }:{
  services.nginx.virtualHosts."sonarr.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:8990";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."~ (/sonarr)?/api" = {
      proxyPass = "http://192.168.1.200:8990";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
