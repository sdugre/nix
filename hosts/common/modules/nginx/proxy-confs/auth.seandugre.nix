{config, ...}: {
  services.nginx.virtualHosts."auth.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9091";
      proxyWebsockets = true;
    };
  };
}
