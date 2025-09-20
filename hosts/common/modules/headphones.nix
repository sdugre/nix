{
  config,
  lib,
  hostname,
  ...
}: let
  app = "headphones";
  domain = "seandugre.com";
  cfg = config.services.headphones;
in {
  services.headphones = {
    enable = true;
    port = 8182;
  };

  # fix permissions that don't get set up correctly by module for some reason
  systemd.tmpfiles.rules = [
    "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
  ];

  networking.firewall.allowedTCPPorts = [ cfg.port ];

  services.nginx.virtualHosts."${app}.${domain}" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://localhost:${toString cfg.port}";
      proxyWebsockets = true;
      extraConfig = ''
      '';
    };
  };

  # Create necessary folders
#  systemd.tmpfiles.rules = [
#    "d ${dataDir}/ 0755 ntfy-sh ntfy-sh -"
#  ];

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "${cfg.dataDir}"
    ];
  };
}
