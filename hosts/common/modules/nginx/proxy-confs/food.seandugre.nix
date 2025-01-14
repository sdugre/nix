{config, ...}: {
  services.nginx.virtualHosts."food.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false; # handled by mealie conifg direclty
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://localhost:9000";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
      '';
    };
  };
}
