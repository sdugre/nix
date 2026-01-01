{
  pkgs,
  config,
  lib,
  hostname,
  ...
}: {
  users.users.vaultwarden.extraGroups = [ "mail" ];

  sops.secrets."vaultwarden-env" = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    domain = "vault.seandugre.com";
    configureNginx = true;
    configurePostgres = true;
    environmentFile = config.sops.secrets.vaultwarden-env.path;
    config = {
      SIGNUPS_ALLOWED = false;
      USE_SENDMAIL = "true";
      SENDMAIL_COMMAND = "${pkgs.msmtp}/bin/msmtp";
      SMTP_FROM = config.programs.msmtp.accounts.default.from;
      SMTP_FROM_NAME = "Vaultwarden";
    };
  };

  services.nginx.virtualHosts.${config.services.vaultwarden.domain}.useACMEHost = "seandugre.com";

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/vaultwarden"
    ];
  };
}
