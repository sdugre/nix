{
  config,
  lib,
  hostname,
  pkgs,
  ...
}: {

  services.mealie = {
    enable = true;
    settings = {
      BASE_URL = "https://food.seandugre.com";
      OIDC_AUTH_ENABLED = "true";
      OIDC_SIGNUP_ENABLED = "true";
      OIDC_CONFIGURATION_URL = "https://auth.seandugre.com/.well-known/openid-configuration";
      OIDC_CLIENT_ID = "mealie";
      OIDC_AUTO_REDIRECT = "true";
      OIDC_ADMIN_GROUP = "admin"; 
      OIDC_USER_GROUP = "user";
      OIDC_PROVIDER_NAME = "Authelia";
    };
    credentialsFile = config.sops.secrets.mealie-secrets.path;
  };

  networking.firewall.allowedTCPPorts = [ 9000 ];

  systemd.services.mealie = {
    # DynamicUser messes with sops-nix
    serviceConfig.DynamicUser = lib.mkForce false;
  };

  # Setup a user and group for Mealie
  users = {
    users.mealie = {
      group = "mealie";
      isSystemUser = true;
    };
      groups.mealie = {};
  };

  services.authelia.instances.main.settings = {
    identity_providers.oidc = {
      cors = {
        allowed_origins_from_client_redirect_uris = true; 
      };
      clients = [
        {
          client_id = "mealie";
          client_name = "Mealie";
          client_secret = "$pbkdf2-sha512$310000$oFZsyx7fnp1EwV.oL8oZ6g$n7NmuRitw0Ga284QJcya4Zl5IGcqND28UP0yBnQpGnnq.G8cnrclk0liVaItWy4YgVB3yzbGHZYquX9.DG97Qw";
          public = false;
          authorization_policy = "one_factor";
          redirect_uris = [
            "https://food.seandugre.com/login"
            "http://localhost:9000/login"
          ];
          scopes = ["openid" "profile" "email" "groups"];
          userinfo_signed_response_alg = "none";
          consent_mode = "implicit";
          pkce_challenge_method = "S256";
          token_endpoint_auth_method = "client_secret_basic";
          grant_types = [ "authorization_code" ];
        }
      ];
    };
  };

  sops.secrets."mealie-secrets" = {
    sopsFile = ../../${hostname}/secrets.yaml;
    mode = "0400";
    owner = "authelia-main";
    group = "authelia-main";
    restartUnits = ["authelia-main.service"];
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/mealie"
    ];
  };
}
