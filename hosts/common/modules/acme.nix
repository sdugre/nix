{
  lib,
  pkgs,
  config,
  hostname,
  ...
}: {
  sops.secrets."cloudflare-creds" = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      group = "nginx";
      email = "sdugre@gmail.com";
    };

    certs."seandugre.com" = {
      extraDomainNames = [
        "*.seandugre.com"
      ];
      environmentFile = config.sops.secrets.cloudflare-creds.path;
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = ["/var/lib/acme"];
  };
}
