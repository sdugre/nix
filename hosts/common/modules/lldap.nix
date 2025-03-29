{
  config,
  lib,
  hostname,
  ...
}: 
let
  app = "ldap";
  domain = "seandugre.com";
in {
  users.users.lldap = {
    name = "lldap";
    group = "lldap";
    description = "LDAP Server User";
    isSystemUser = true;
  };
  users.groups.lldap = {};

  sops = {
    secrets = let
      sopsFile = ../../${hostname}/secrets.yaml;
      owner = config.systemd.services.lldap.serviceConfig.User;
      group = config.systemd.services.lldap.serviceConfig.Group;
      restartUnits = ["lldap.service"];
      cfg = {
        inherit owner group restartUnits sopsFile;
      };
    in {
      "lldap/jwt_secret" = cfg;
      "lldap/key_seed" = cfg;
      "lldap/user_password" = cfg;
    };
  };

  services.lldap = {
    enable = true;
    settings = {
      ldap_base_dn = "dc=seandugre,dc=com";
      ldap_user_email = "sdugre@gmail.com";
    };
    environment = {
      LLDAP_JWT_SECRET_FILE = config.sops.secrets."lldap/jwt_secret".path;
      LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets."lldap/user_password".path;
      LLDAP_KEY_SEED_FILE = config.sops.secrets."lldap/key_seed".path;
    };
  };

  services.nginx.virtualHosts."${app}.${domain}" = {
    useACMEHost = "${domain}";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.lldap.settings.http_port}";
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/private/lldap"
    ];
  };
}
