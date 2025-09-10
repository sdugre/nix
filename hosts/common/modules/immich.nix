{
  config,
  lib,
  ...
}: let
  app = "photos";
  domain = "seandugre.com";
in 
{
  users.groups.photos = {};

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    group = "photos";
    environment.IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
  };

  networking.firewall.allowedTCPPorts = [2283 3003];

  services.nginx.virtualHosts."${app}.${domain}" = {
    useACMEHost = "${domain}";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:2283";
      proxyWebsockets = true;
    };
  };

  # NOTE: There doesn't appear to be a declarable way to add extra attributes
  #       in lldap.  I had to create it in the web interface.
  services.authelia.instances.main.settings.authentication_backend.ldap = {
    attributes.extra = {
      immichquota = {
        name = "immich_quota";
        multi_valued = false;
        value_type = "integer";
      };
    };
  };

  services.authelia.instances.main.settings.definitions = {
    user_attributes = {
      immich_role = {
        expression = ''
          "immich-admins" in groups ? "admin" :
          "immich-users" in groups ? "user" :
          ""
        '';
      };
    };
  };

  services.authelia.instances.main.settings.identity_providers.oidc = {
    claims_policies.immich_policy.custom_claims = {
      "immich_quota".attribute = "immich_quota";
      "immich_role".attribute = "immich_role";
    };

    scopes."immich_scope".claims = [
      "immich_quota"
      "immich_role"
    ];

    clients = [
      {
        client_id = "immich";
        client_name = "Immich";
        client_secret = "$pbkdf2-sha512$310000$w9sPA8EpbUZgvslYEkkBpg$6forQMvb5TXkiidrfzPdsWH63iLQd9afQ2JSQl6.o4xjWFPMgJhKcyi4PyTgTjddxGoetgRNp5BOhgfTMDinjA";
        public = false;
        require_pkce = false;
        redirect_uris = [
          "https://photos.seandugre.com/auth/login"
          "https://photos.seandugre.com/user-settings"
          "app.immich:///oauth-callback"
        ];
        scopes = [
          "openid"
          "profile"
          "email"
          "immich_scope"
        ];
        claims_policy = "immich_policy";
        response_types = [ "code" ];
        grant_types = [ "authorization_code" ];
        id_token_signed_response_alg = "RS256";
        userinfo_signed_response_alg = "RS256";
        token_endpoint_auth_method = "client_secret_post";
        consent_mode = "pre-configured";
        pre_configured_consent_duration = "14 days";
      }
    ];
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/immich"
    ];
  };
}
