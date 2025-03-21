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

    # optional
    ../common/optional/networkDrives.nix
    ../common/optional/pipewire.nix
    ../common/optional/electronics.nix
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
      ifuse # optional, to mount using 'ifuse'
      libreoffice-qt # office suite
      libimobiledevice # iphone mount
      remmina   # RDP
      wireshark # network monitoring tool
      xournalpp # annotate pdfs
      kitty
    ]);

  networking.firewall.allowedTCPPorts = [ 
    3389    # RDM for remmina
  ]; 

  services.usbmuxd.enable = true; # for iphone mount
}
