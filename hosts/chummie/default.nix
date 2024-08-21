  
{ inputs, outputs, lib, config, pkgs, nixos-hardware, ... }: {
  imports = [
    ./hardware-configuration.nix

    # optional
    ../common/optional/networkDrives.nix
#    ../common/modules/persistence.nix

    # services
    ../common/modules/acme.nix      # certs
    ../common/modules/authelia.nix  # SSO
#    ../common/modules/calibre.nix   # eBooks
    ../common/modules/ddclient.nix  # DDNS updating
#    ../common/modules/frigate.nix   # NVR
    ../common/modules/gonic.nix     # Music Server
    ../common/modules/mail.nix      # Mail server for notifications
    ../common/modules/nextcloud.nix # Cloud
    ../common/modules/nfs.nix       # NFS server
    ../common/modules/nginx         # reverse proxy
#    ../common/modules/nixarr.nix    # Media aquisition - use containers instead
    ../common/modules/paperless.nix # Documents
    ../common/modules/plex.nix      # Plex Media Server
    ../common/modules/containers    # Podman Containers
    ../common/modules/rss.nix       # miniflux & rss-bridge
  ];

  # FOR QUICKSYNC
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      #... # your Open GL, Vulkan and VAAPI drivers
      intel-media-sdk   # for older GPUs
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
#  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  # FOR ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "a610158c";

  services.zfs.autoScrub.enable = true;
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "root" ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  # this option does not work; will return error
  services.zfs.zed.enableMail = false;



  # START Home Assistant VM
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.1" "8.8.8.8" ];
  networking.useDHCP = false;
  networking.bridges.br0.interfaces = ["eno2"];
  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [{
      "address" = "192.168.1.200";
      "prefixLength" = 24;
    }];
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      # Used for UEFI boot of Home Assistant OS guest image
      qemu.ovmf.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/libvirt" 
      "/etc/vmimages"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 5900 5901 1935 ];

  # END Home Assistand VM


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
    xclip
    pciutils
    inxi
    smartmontools
    s-tui
    zfs
    virt-viewer
  ]);
}
