{ lib, config, ... }:

let
  hasPersistence = config.environment.persistence ? "/persist";
in
{
  services.tailscale.enable = true;

  environment.persistence = {
    "/persist".directories = [ "/var/lib/tailscale" ];
  };
}
