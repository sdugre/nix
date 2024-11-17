{
  config,
  lib,
  ...
}: {
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    environment.IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
  };

  networking.firewall.allowedTCPPorts = [2283 3003];

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/immich"
    ];
  };
}
