{ lib, pkgs, config, ... }:{

  imports = [ ./proxy-confs ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.enable = true;

#   services.nginx.virtualHosts."rsss.seandugre.com" = {
#     useACMEHost = "seandugre.com";
#     forceSSL = true;
# #    enableAuthelia = true;
#     locations."/" = {
#       proxyPass = "http://127.0.0.1:${toString config.services.miniflux.config.PORT}";
#       proxyWebsockets = true;
#     };
#   };

#   services.nginx.virtualHosts."rsss-bridge.seandugre.com" = {
#     useACMEHost = "seandugre.com";
#     forceSSL = true;
#  #   enableAuthelia = true;
#     # remainder is set in rss-bridge module itself
#   };

#   services.nginx.virtualHosts."auth.seandugre.com" = {
#     useACMEHost = "seandugre.com";
#     forceSSL = true;
#     acmeRoot = null;
#     locations."/" = {
#       proxyPass = "http://127.0.0.1:9091";
#       proxyWebsockets = true;
#     };
#   };
}
