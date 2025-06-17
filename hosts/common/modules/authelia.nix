{
  lib,
  pkgs,
  config,
  hostname,
  ...
}: {
  sops = {
    secrets = let
      sopsFile = ../../${hostname}/secrets.yaml;
      mode = "0400";
      owner = "authelia-main";
      group = "authelia-main";
      restartUnits = ["authelia-main.service"];
      cfg = {
        inherit owner group mode restartUnits sopsFile;
      };
    in {
      "authelia/jwtSecretFile" = cfg; 
      "authelia/storageEncryptionKeyFile" = cfg;
      "authelia/sessionSecretFile" = cfg;
      "authelia_login" = cfg;
      "authelia/oidcHmacSecretFile" = cfg;
      "authelia/oidcIssuerPrivateKeyFile" = cfg;
      "authelia/lldap" = cfg;
      "authelia/gmail_token" = cfg;
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/authelia-main"
    ];
  };

  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = config.sops.secrets."authelia/jwtSecretFile".path;
      storageEncryptionKeyFile = config.sops.secrets."authelia/storageEncryptionKeyFile".path;
      sessionSecretFile = config.sops.secrets."authelia/sessionSecretFile".path;
      oidcIssuerPrivateKeyFile = config.sops.secrets."authelia/oidcIssuerPrivateKeyFile".path;
      oidcHmacSecretFile = config.sops.secrets."authelia/oidcHmacSecretFile".path;
    };
    environmentVariables = {
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.sops.secrets."authelia/lldap".path;
      AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = config.sops.secrets."authelia/gmail_token".path;
    };
    settings = {
      theme = "dark";
      default_redirection_url = "https://seandugre.com";

      server = {
        address = "127.0.0.1:9091";
      };

      log = {
        level = "debug";
        format = "text";
      };

      authentication_backend = {
        password_reset.disable = false;
        refresh_interval = "1m";
        ldap = {
          implementation = "custom";
          address = "ldap://127.0.0.1:${toString config.services.lldap.settings.ldap_port}";
          timeout = "5m";
          start_tls = false;
          base_dn = "dc=seandugre,dc=com";
          additional_users_dn = "ou=people";
          users_filter = "(&({username_attribute}={input})(objectClass=person))";
          additional_groups_dn = "ou=groups";
          groups_filter = "(member={dn})";
          attributes = {
            username = "uid";
            member_of = "memberOf";
            group_name = "cn";
            mail = "mail";
            display_name = "displayName";
          };
          user = "uid=admin,ou=people,dc=seandugre,dc=com";
        };
      };

      identity_providers.oidc = {
        cors = {
          endpoints = [
            "authorization"
            "token"
            "revocation"
            "introspection"
            "userinfo"
          ];
        };
      };

      totp = {
        disable = false;
        issuer = "seandugre.com";
      };

      access_control = {
        default_policy = "deny";
        networks = [
          {
            name = "internal";
            networks = ["10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/18"];
          }
        ];
        rules = [
          {
            domain = ["auth.seandugre.com"];
            policy = "bypass";
          }
#          {
#            domain = ["money.seandugre.com"];
#            policy = "two_factor";
#          }
          {
            domain = ["ldap.seandugre.com"];
            networks = "internal";
            subject = ["user:sdugre"];
            policy = "one_factor";
          }
          {
            domain = ["ldap.seandugre.com"];
            policy = "deny";
          }
          {
            domain = ["*.seandugre.com"];
            networks = "internal";
            policy = "bypass";
          }
          {
            domain = ["*.seandugre.com"];
            policy = "one_factor";
          }
        ];
      };

      session = {
        name = "authelia_session";
        expiration = "12h";
        inactivity = "45m";
        remember_me_duration = "1M";
        domain = "seandugre.com";
        redis.host = "/run/redis-authelia-main/redis.sock";
      };

      regulation = {
        max_retries = 3;
        find_time = "5m";
        ban_time = "15m";
      };

      storage = {local = {path = "/var/lib/authelia-main/db.sqlite3";};};

      notifier = {
        disable_startup_check = false;
        smtp = {
          address = "submission://smtp.gmail.com:587";
          username = "sdugre@gmail.com";
          sender = "admin@seandugre.com";
        };
      };
    };
  };

  services.redis.servers.authelia-main = {
    enable = true;
    user = "authelia-main";
    port = 0;
    unixSocket = "/run/redis-authelia-main/redis.sock";
    unixSocketPerm = 600;
  };

  services.nginx.virtualHosts."auth.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    acmeRoot = null;

    locations."/" = {
      proxyPass = "http://127.0.0.1:9091";
      proxyWebsockets = true;
    };
  };
}
