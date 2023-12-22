
{ inputs, outputs, lib, config, pkgs, nixos-hardware, ... }: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
 
    # optional
    ../common/optional/networkDrives.nix
    ../common/optional/pipewire.nix
    ../common/optional/laptop.nix
    ../common/optional/electronics.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = ([
  ]) ++ (with pkgs; [
    wireshark
    backlight
  ]);

  # udev rule to allow adjusting brightness
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  networking.firewall.allowedTCPPorts = [ 3389 ];

}
