
{ inputs, outputs, lib, config, pkgs, nixos-hardware, ... }: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/sdugre

    ../common/optional/networkDrives.nix
#    ../common/optional/gnome.nix
    ../common/optional/hyprland.nix
    inputs.hyprland.nixosModules.default
   
    ../common/optional/pipewire.nix
    ../common/optional/laptop.nix
    ../common/optional/electronics.nix
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  environment.systemPackages = ([
    inputs.agenix.packages.x86_64-linux.default
  ]) ++ (with pkgs; [
    mnamer
    wireshark
    backlight
 
  ]);

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # udev rule to allow adjusting brightness
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  # TODO: Set your hostname
  networking.hostName = "thinkpad";

  networking.firewall.allowedTCPPorts = [ 3389 ];

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
#  boot.loader.grub.enable = true;
#  boot.loader.grub.device = "/dev/sda";
#  boot.loader.grub.useOSProber = true;
#  boot.loader.grub.configurationLimit = 10;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "yes";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

}
