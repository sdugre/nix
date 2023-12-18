# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    # optional
    ../common/optional/networkDrives.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 10;

  environment.systemPackages = ([
  ]) ++ (with pkgs; [
    wireshark 
  ]);

  networking.firewall.allowedTCPPorts = [ 3389 ]; 

}
