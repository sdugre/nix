{ config, ... }:{
  services.nginx.virtualHosts."plex.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
      client_max_body_size 0;
      proxy_redirect off;
      proxy_buffering off;
    '';
    locations."/" = {
      proxyPass = "http://192.168.58:32400";
      proxyWebsockets = true;
      extraConfig = ''
        resolver 127.0.0.11 valid=30s;
        proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
        proxy_set_header X-Plex-Device $http_x_plex_device;
        proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
        proxy_set_header X-Plex-Platform $http_x_plex_platform;
        proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
        proxy_set_header X-Plex-Product $http_x_plex_product;
        proxy_set_header X-Plex-Token $http_x_plex_token;
        proxy_set_header X-Plex-Version $http_x_plex_version;
        proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
        proxy_set_header X-Plex-Provides $http_x_plex_provides;
        proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
        proxy_set_header X-Plex-Model $http_x_plex_model;
      '';
    };
  };
}
