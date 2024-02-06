{ config, ... }:{
  services.nginx.virtualHosts."docs.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
      client_max_body_size 10M;
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.58:8000";
      proxyWebsockets = true;
    };
  };
}
