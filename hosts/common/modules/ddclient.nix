{ config, hostname, ... }: {

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
    use = "web,web=ifconfig.me/ip";
    verbose = true;
    zone = "seandugre.com";
  };
}
