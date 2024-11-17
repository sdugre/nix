{config, ...}: {
  services.nginx.virtualHosts."pdf.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8783";
      proxyWebsockets = true;
    };
  };
}
