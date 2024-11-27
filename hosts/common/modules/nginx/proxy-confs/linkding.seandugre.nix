{config, ...}: {
  services.nginx.virtualHosts."linkding.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/linkding" = {
      proxyPass = "http://192.168.1.200:9090";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
