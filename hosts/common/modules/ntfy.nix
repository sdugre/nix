{
  config,
  lib,
  hostname,
  ...
}: let
  app = "ntfy";
  domain = "seandugre.com";
  port = 5600;
  dataDir = "/var/lib/ntfy";
in
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = "127.0.0.1:${toString port}";
      base-url = "https://${app}.${domain}";
      upstream-base-url = "https://ntfy.sh"; # needed for instant iOS messages
      auth-file = "${dataDir}/user.db";
      auth-default-access = "deny-all";
      behind-proxy = true;
    };
  };

  networking.firewall.allowedTCPPorts = [port];

  systemd.services.ntfy-sh = {
    # DynamicUser seems to cause permissions issues
    serviceConfig.DynamicUser = lib.mkForce false;
  };

  services.nginx.virtualHosts."${app}.${domain}" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = false;
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
  systemd.tmpfiles.rules = [
    "d ${dataDir}/ 0755 ntfy-sh ntfy-sh -"
  ];
}
