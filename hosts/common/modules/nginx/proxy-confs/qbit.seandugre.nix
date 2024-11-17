{config, ...}: {
  services.nginx.virtualHosts."qbit.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    locations."/" = {
      proxyPass = "http://192.168.1.200:8283";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
        proxy_set_header Host 192.168.1.200:8283;
        proxy_set_header X-Forwarded-Host $host;
      '';
    };
  };
}
