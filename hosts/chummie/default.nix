  
{ inputs, outputs, lib, config, pkgs, nixos-hardware, ... }: {
  imports = [
    ./hardware-configuration.nix

    # optional
    ../common/optional/networkDrives.nix
#    ../common/modules/persistence.nix
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

  services.miniflux = {
    enable = true;
    config = {
      PORT = "8087";
    };
    # Set initial admin user/password
    adminCredentialsFile = pkgs.writeText "cred" ''
      ADMIN_USERNAME=miniflux
      ADMIN_PASSWORD=miniflux
    '';
  };

  networking.firewall.allowedTCPPorts = [ 8087 ];
  networking.firewall.allowedUDPPorts = [ 8087 ];

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
  ]);
}
