{ config, lib, hostname, ... }: {

  sops.secrets."cloudflare-api-token" = { 
    sopsFile = ../../${hostname}/secrets.yaml; 
    mode = "0400";
  };

# source:  https://github.com/JayRovacsek/nix-config/blob/main/modules/ddclient/default.nix
  services.ddclient = {
    #inherit (config.services.nginx) domains;
    enable = true;
    domains = [ "seandugre.com" ];
    interval = "5min";
    username = "token";
    passwordFile = config.sops.secrets.cloudflare-api-token.path;
    protocol = "cloudflare";
    ssl = true;
    usev4 = "webv4,webv4=ifconfig.me/ip";
    verbose = true;
    zone = "seandugre.com";
  };


  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/private/ddclient" 
    ];
  };

}
