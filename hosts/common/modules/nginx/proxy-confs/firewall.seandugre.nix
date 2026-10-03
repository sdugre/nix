{ ... }: {
  services.nginx.virtualHosts."firewall.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;

    locations."/" = {
      proxyPass = "https://192.168.1.1";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_ssl_verify off;
      '';
    };
  };
}
