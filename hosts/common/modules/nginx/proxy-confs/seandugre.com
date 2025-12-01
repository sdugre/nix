{config, ...}: {
  services.nginx.virtualHosts."seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    root = "/var/www/seandugre.com/public";
  };
}
