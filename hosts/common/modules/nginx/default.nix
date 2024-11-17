{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./proxy-confs
    ./nginx-extra-options.nix
  ];

  networking.firewall.allowedTCPPorts = [80 443];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
