{
  lib,
  config,
  ...
}: {
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  users.groups.media = {};
  users.users.plex.extraGroups = ["media"];

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/plex"
    ];
  };
}
