{config, ...}: {
  services.nginx.virtualHosts."nvr.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    # remainder is set in frigate module itself
  };
}
