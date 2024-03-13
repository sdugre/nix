  
{ inputs, outputs, lib, config, pkgs, nixos-hardware, ... }: {
  imports = [
    ./hardware-configuration.nix

    # optional
    ../common/optional/networkDrives.nix
#    ../common/modules/persistence.nix

    # services
    ../common/modules/rss.nix       # miniflux & rss-bridge
    ../common/modules/acme.nix      # certs
    ../common/modules/nginx         # reverse proxy
    ../common/modules/authelia.nix  # SSO
    ../common/modules/ddclient.nix  # DDNS updating
    ../common/modules/plex.nix      # Plex Media Server
#    ../common/modules/frigate.nix   # NVR
#    ../common/modules/paperless.nix # Documents
    ../common/modules/nextcloud.nix # Cloud
    ../common/modules/gonic.nix     # Music Server
#    ../common/modules/nixarr.nix    # Media aquisition
  ];

  services.persistence = {
    enable = true;
    partition = "nvme0n1p3";
  };

  services.tailscaleAutoconnect = {
    enable = true;
    authkeyFile = config.sops.secrets.tailscale_key.path;
    loginServer = "";
    enableSSH = true;
  };
  
  sops.secrets.tailscale_key = { 
    sopsFile = ./secrets.yaml; 
  };

  # filesystems
  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];
  fileSystems."/persist".options = [ "compress=zstd" "noatime" ];
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".options = [ "compress=zstd" "noatime" ];
  fileSystems."/var/log".neededForBoot = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Packages specific to this machine
  environment.systemPackages = ([
  ]) ++ (with pkgs; [
    lemonade
    pia-wg-config
  ]);
}
