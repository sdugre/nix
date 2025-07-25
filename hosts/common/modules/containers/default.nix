{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./bibliotheca.nix         # goodreads alternative
    ./calibre.nix             # can't get to native nix package to work
    #  ./calibre-web.nix      # use native nix package
    ./chowdown.nix            # recipe wiki
    ./dawarich.nix            # location tracking
    #  ./frigate.nix          # use native nix package
    #  ./jellyfin.nix         # use native nix package
    ./jelu.nix                # goodreads alternative
    ./linkding.nix            # bookmark manager
    ./lubelogger.nix          # automobile maintenance logging
    ./media.nix               # arr stack w/ gluetun for vpn
    ./photon.nix              # geocoding service (used by dawarich)
    # ./tube-archivist.nix    # works, but doesn't auto delete or rename files. Use ytdl-sub instead
    ./ytdl-sub.nix            # youTube downloader
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "podman";

  # Create folders for the containers
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers -o root -g root
    '';
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/containers"
    ];
  };
}
