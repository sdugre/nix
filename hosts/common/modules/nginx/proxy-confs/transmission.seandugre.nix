{config, ...}: {
  services.nginx.virtualHosts."transmission.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:9092";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
        proxy_pass_header X-Transmission-Session-Id;
      '';
    };
    locations."~ (/transmission)?/rpc" = {
      proxyPass = "http://192.168.1.200:9092";
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
      '';
    };
  };
}
