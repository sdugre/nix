{config, ...}: {
  services.nginx.virtualHosts."nvr2.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    # remainder is set in rss-bridge module itself
  };
}
