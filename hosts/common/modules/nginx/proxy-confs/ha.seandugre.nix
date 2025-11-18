{config, ...}: 
  let 
    haIP = "192.168.1.201";
  in {

  # NOTE:  For this to work, had to add nginx proxy ip (192.168.1.200) to
  #        trusted proxies under http in Home Assistant configuration.yaml config.

  services.nginx.virtualHosts."ha.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://${haIP}:8123/";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
    locations."/api/websocket" = {
      proxyPass = "http://${haIP}:8123/api/websocket";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
