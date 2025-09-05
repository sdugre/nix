{ config, pkgs, lib, hostname, ... }:
let
  cfg = config.services.forgejo;
  svr = cfg.settings.server;
  domain = "git.seandugre.com";
in
{

  # fix permissions that don't get set up correctly by module for some reason
  systemd.tmpfiles.rules = [
    "d ${cfg.stateDir} 0750 ${cfg.user} ${cfg.group} - -"
  ];

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    settings = {
      server = {
        DOMAIN = domain;
        ROOT_URL = "https://${svr.DOMAIN}/";
        HTTP_PORT = 3333;  # default 3000 is in use;
        LANDING_PAGE = "explore";
      };
      service.DISABLE_REGISTRATION = true; 
      overall.APP_NAME = "";
    };
  };

  sops.secrets.forgejo-admin-password = {
    sopsFile = ../../${hostname}/secrets.yaml;
    owner = "${cfg.user}";
    group = "${cfg.group}";
  };

  # ensure users
  systemd.services.forgejo.preStart = let 
    adminCmd = "${lib.getExe cfg.package} admin user";
    pwd = config.sops.secrets.forgejo-admin-password;
    user = "sdugre"; # Note, Forgejo doesn't allow creation of an account named "admin"
  in ''
    ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    ## uncomment this line to change an admin user which was already created
    # ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
  '';

  services.nginx.virtualHosts.${svr.DOMAIN} = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
      client_max_body_size 512M;
    '';
    locations."/" = {
      proxyPass = "http://localhost:${toString svr.HTTP_PORT}";
      proxyWebsockets = true;
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "${cfg.stateDir}"
    ];
  };

}

