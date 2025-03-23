{ config, 
  hostname,
  ...
}:
{

  sops.secrets."nix-serve/private" = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

  services.nix-serve = {
    enable = true;
    #secretKeyFile = "/var/secrets/cache-private-key.pem";
    secretKeyFile = config.sops.secrets."nix-serve/private".path;
    port = 5511;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts.bin-cache = {
      locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
    };
  };

  networking.firewall.allowedTCPPorts = [
    config.services.nginx.defaultHTTPListenPort
  ];
}
