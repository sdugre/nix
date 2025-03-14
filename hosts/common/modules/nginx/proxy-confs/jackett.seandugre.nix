{config, ...}: {
  services.nginx.virtualHosts."jackett.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:9118";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."~ (/jackett)?/api" = {
      proxyPass = "http://192.168.1.200:9118";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."~ (/jackett)?/dl" = {
      proxyPass = "http://192.168.1.200:9118";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
