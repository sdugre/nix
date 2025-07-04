{
  config,
  lib,
  hostname,
  ...
}: let
  app = "homebox";
  domain = "seandugre.com";
  port = 7745;
  dataDir = "/var/lib/homebox";
in {
  services.homebox = {
    enable = true;
    settings = {
      HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
    };
  };

  networking.firewall.allowedTCPPorts = [port];

  services.nginx.virtualHosts."${app}.${domain}" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
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
      "${dataDir}"
    ];
  };
}
