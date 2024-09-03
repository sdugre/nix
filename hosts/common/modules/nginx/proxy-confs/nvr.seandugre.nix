{ config, ... }:{
  services.nginx.virtualHosts."nvr.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $http_connection;
      proxy_http_version 1.1;
    '';
    locations."/" = {
      proxyPass = "https://192.168.1.202:8971";
      proxyWebsockets = false;
      extraConfig = ''
#        resolver 127.0.0.11 valid=30s;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        proxy_http_version 1.1;
      '';
    };
  };
}
