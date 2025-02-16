{
  config,
  lib,
  ...
}: let
  app = "photos";
  domain = "seandugre.com";
in 
{
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    environment.IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
  };

  networking.firewall.allowedTCPPorts = [2283 3003];

  services.nginx.virtualHosts."${app}.${domain}" = {
    useACMEHost = "${domain}";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true;
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/immich"
    ];
  };
}
