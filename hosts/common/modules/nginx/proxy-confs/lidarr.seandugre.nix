{ config, ... }:{
  services.nginx.virtualHosts."lidarr.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:8687";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."~ (/lidarr)?/api" = {
      proxyPass = "http://192.168.1.200:8687";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
