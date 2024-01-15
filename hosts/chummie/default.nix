  
{ inputs, outputs, lib, config, pkgs, nixos-hardware, ... }: {
  imports = [
    ./hardware-configuration.nix

    # optional
    ../common/optional/networkDrives.nix
    ../common/modules/persistence.nix
  ];

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
  ]);
}
