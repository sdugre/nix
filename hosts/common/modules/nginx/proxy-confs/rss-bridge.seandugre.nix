{config, ...}: {
  services.nginx.virtualHosts."rss-bridge.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    # remainder is set in rss-bridge module itself
  };
}
