{config, ...}: {
  # NOTE:  For this to work, had to add 192.168.1.66 to trusted proxies under http in
  #        Home Assistent configuration.yaml config.
  services.nginx.virtualHosts."ha.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.43:8123/";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."/api/websocket" = {
      proxyPass = "http://192.168.1.43:8123/api/websocket";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
