{ config, ... }:{
  services.nginx.virtualHosts."tv.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.58:5055";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
