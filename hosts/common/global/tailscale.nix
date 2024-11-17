{
  lib,
  config,
  ...
}: let
  hasPersistence = config.environment.persistence ? "/persist";
in {
  services.tailscale.enable = true;

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = ["/var/lib/tailscale"];
  };
}
