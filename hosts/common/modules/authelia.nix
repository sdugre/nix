{ lib, pkgs, config, hostname,... }:
{
  sops.secrets."authelia/jwtSecretFile" = { 
    sopsFile = ../../${hostname}/secrets.yaml; 
    mode = "0400";
    owner = "authelia-main";
    group = "authelia-main";
    restartUnits = [ "authelia.service" ];
  };

  sops.secrets."authelia/storageEncryptionKeyFile" = { 
    sopsFile = ../../${hostname}/secrets.yaml;   
    mode = "0400";
    owner = "authelia-main";
    group = "authelia-main";
    restartUnits = [ "authelia.service" ];
  };

  sops.secrets."authelia/sessionSecretFile" = { 
    sopsFile = ../../${hostname}/secrets.yaml;   
    mode = "0400";
    owner = "authelia-main";
    group = "authelia-main";
    restartUnits = [ "authelia.service" ];
  };

  sops.secrets."authelia_login" = { 
    sopsFile = ../../${hostname}/secrets.yaml;   
    mode = "0400";
    owner = "authelia-main";
    group = "authelia-main";
    restartUnits = [ "authelia.service" ];
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
    };

    settings = {
      theme = "dark";
      default_redirection_url = "https://seandugre.com";

      server = {
        host = "127.0.0.1";
        port = 9091;
      };

      log = {
        level = "debug";
        format = "text";
      };

      authentication_backend = {
        file = { 
          path = config.sops.secrets."authelia_login".path; 
          watch = false;
          search = {
            email = false;
            case_insensitive = false;
          };
          password = {
            algorithm = "argon2";
            argon2 = {
              variant = "argon2id";
              iterations = 3;
              memory = 65536;
              parallelism = 4;
              key_length = 32;
              salt_length = 16;
            };
          };
        };
      };

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = [ "auth.seandugre.com" ];
            policy = "bypass";
          }
          {
            domain = [ "*.seandugre.com" ];
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

      storage = { local = { path = "/var/lib/authelia-main/db.sqlite3"; }; };

      notifier = {
        disable_startup_check = false;
        filesystem = { filename = "/var/lib/authelia-main/notification.txt"; };
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
