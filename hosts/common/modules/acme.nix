{ lib, pkgs, config, hostname,... }:
{

  sops.secrets."cloudfare-creds" = { 
    sopsFile = ../../${hostname}/secrets.yaml; 
  };

  security.acme = {
    acceptTerms = true;
    defaults = { 
      group = "nginx";
      email = "sdugre@gmail.com";
      credentialsFile = config.sops.secrets.cloudfare-creds.path;
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";      
    };

    certs."seandugre.com" = {
      extraDomainNames = [ "*.seandugre.com" ];
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ "/var/lib/acme" ];
  };

}
