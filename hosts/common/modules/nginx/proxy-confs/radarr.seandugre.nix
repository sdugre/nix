{ config, ... }:{
  services.nginx.virtualHosts."radarr.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.58:7878";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."~ (/radarr)?/api" = {
      proxyPass = "http://192.168.1.58:7878";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
