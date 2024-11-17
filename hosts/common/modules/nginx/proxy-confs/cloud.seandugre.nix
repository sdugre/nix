{config, ...}: {
  services.nginx.virtualHosts."cloud.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    # the rest handled by the module
    # locations."/" = {
    #   proxyPass = "https://192.168.58:4043";
    #   proxyWebsockets = true;
    #   extraConfig = ''
    #     resolver 127.0.0.11 valid=30s;
    #     proxy_max_temp_file_size 2048m;
    #   '';
    # };
  };
}
