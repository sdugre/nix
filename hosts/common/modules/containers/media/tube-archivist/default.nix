{
  config,
  pkgs,
  hostname,
  ...
}: let
  TUBEARCHIVIST_CREDS = config.sops.secrets.tube-archivist-env.path;
  TUBEARCHIVIST_ELASTIC_CREDS = config.sops.secrets.tube-archivist-elastic-env.path;
in {
  # we create a systemd service so that we can create a single "pod"
  # for our containers to live inside of. This will mimic how docker compose
  # creates one network for the containers to live inside of

  sops.secrets."tube-archivist-env" = {
    sopsFile = ../../../../../${hostname}/secrets.yaml;
  };

  sops.secrets."tube-archivist-elastic-env" = {
    sopsFile = ../../../../../${hostname}/secrets.yaml;
  };

  systemd.services.create-tube-archivist-network = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [
      "${backend}-tube-archivist-app.service"
      "${backend}-tube-archivist-es.service"
      "${backend}-tube-archivist-redis.service"
    ];
    script = ''
      ${pkgs.podman}/bin/podman network exists ta-net || \
      ${pkgs.podman}/bin/podman network create ta-net
    '';
  };

  tube-archivist-app =
    import ./app.nix
    [
      TUBEARCHIVIST_CREDS
      TUBEARCHIVIST_ELASTIC_CREDS
    ];
  tube-archivist-es =
    import ./es.nix
    [TUBEARCHIVIST_ELASTIC_CREDS];
  tube-archivist-redis = import ./redis.nix;
}
