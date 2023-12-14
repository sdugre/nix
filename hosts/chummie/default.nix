
{ inputs, outputs, lib, config, pkgs, nixos-hardware, ... }: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
    ../common/global
#    ../common/users/sdugre    LEAVE THIS OUT FOR NOW AND USE BELOW USER CONFIG

    ../common/optional/networkDrives.nix
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

  networking.hostName = "chummie"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Packages specific to this machine
  environment.systemPackages = ([
  ]) ++ (with pkgs; [
  ]);

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.sdugre = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ ];
    hashedPassword = "$6$uCu95xgOjbsJEWGn$Wyqm4AG0SW9e93MNWcqLXWlsYUZVm7cSKCV8u3brmqbyxcUxmRCKFlS/J1LVxohIhuaFGFNSHXhJK2aUR7BZF0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP08ryfgQQWLbhbNYqwEBTKCBIArQPalcjtRo54mpr/v sdugre@gmail.com" # thinkpad
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11"; # Did you read the comment?
}
