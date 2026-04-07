{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    inputs.disko.nixosModules.disko

    # optional
#    ../common/optional/networkDrives.nix

    # services
    #../common/modules/backup.nix        # Restic and postgresql backups
  #  ../common/modules/binary-cache.nix  # Binary Cache for nix builds
    #../common/modules/mail.nix          # Mail server for notifications
  #  ../common/modules/ntfy.nix          # Notification service
  #  ../common/modules/remote-builder.nix# Distributed Nix Builds
  #  ../common/modules/samba.nix         # Samba server
  ];

  # FOR ZFS
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "a610158c";

  services.zfs.autoScrub.enable = true;
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = ["root"];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  # this option does not work; will return error
  services.zfs.zed.enableMail = false;

  services.persistence = {
    enable = true;
    partition = "nvme0n1p2";
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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Packages specific to this machine
  environment.systemPackages =
    [
    ]
    ++ (with pkgs; [
      abcde # cd ripper
      pciutils
      smartmontools
      zfs
    ]);
}
