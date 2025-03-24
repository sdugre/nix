{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nixos-hardware,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490

    # optional
    ../common/optional/bluetooth.nix
    ../common/optional/networkDrives.nix
    ../common/optional/pipewire.nix
    ../common/optional/laptop.nix
    ../common/modules/colors.nix
    ../common/modules/distributed-builds.nix

  ];

  services.tailscaleAutoconnect = {
    enable = true;
    authkeyFile = config.sops.secrets.tailscale_key.path;
    loginServer = "";
    enableSSH = true;
    exitNode = "100.89.245.83";
    exitNodeAllowLanAccess = true;
  };

  sops.secrets.tailscale_key = {
    sopsFile = ./secrets.yaml;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages =
    [
    ]
    ++ (with pkgs; [
      backlight # personal script for brightness control
#      config.nur.repos.shados.tmm
      ifuse # optional, to mount using 'ifuse'
      lemonade # copy paste for nvim
      libreoffice-qt # office suite
      libimobiledevice # iphone mount
      python311Packages.requests # may be necessary for beets plugin
      remmina   # RDP
      virt-viewer
      wireshark # network monitoring tool
      xournalpp # annotate pdfs
    ]);

  # udev rule to allow adjusting brightness
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  networking.firewall.allowedTCPPorts = [ 
    3389    # RDM for remmina
    2489    # lemonade 
  ]; 

  services.usbmuxd.enable = true; # for iphone mount

  nix.settings = {
    extra-substituters = [ "http://bin-cache" ];
    extra-trusted-public-keys = [ "bin-cache:9K9KsjABYjB7rh7xfL6UyDvw5E5wp3lxiUSuSYw0cAM=%" ];
  };
}
