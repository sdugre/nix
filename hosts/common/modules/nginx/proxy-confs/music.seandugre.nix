{ config, ... }:{
  services.nginx.virtualHosts."music.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4747";
      proxyWebsockets = true;
#      extraConfig = ''
#        proxy_set_header X-Real-IP         $remote_addr;
#        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
#        proxy_set_header X-Forwarded-Proto https;
#        proxy_set_header Host              $host;
#        proxy_max_temp_file_size           0;
#      '';
    };
  };
}
