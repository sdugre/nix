{ ... }: {
  services.nginx.virtualHosts."adguard.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;

    locations."/" = {
      proxyPass = "http://192.168.1.1:3000";
      proxyWebsockets = true;
    };
  };
}
