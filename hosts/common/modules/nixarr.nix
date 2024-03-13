{ lib, pkgs, config, inputs, ... }:{

  imports = [
    inputs.nixarr.nixosModules.default
  ];

  networking.firewall.allowedTCPPorts = [ 9092 ];
  networking.firewall.allowedUDPPorts = [ 9092 ];

  nixarr = {
    enable = true;
    mediaDir = "/var/lib/nixarr/media";
    stateDir = "/var/lib/nixarr/data/.state/nixarr";

    vpn = {
      enable = true;
      # IMPORTANT: This file must _not_ be in the config git directory
      # You can usually get this wireguard file from your VPN provider
      wgConf = "/var/lib/nixarr/data/.secrets/wg0.conf";
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 50000; # Set this to the port forwarded by your VPN
      uiPort = 9092;
      flood.enable = true;
    };

    # It is possible for this module to run the *Arrs through a VPN, but it
    # is generally not recommended, as it can cause rate-limiting issues.
    sonarr.enable = true;
    radarr.enable = true;
    prowlarr.enable = true;
    readarr.enable = true;
    lidarr.enable = true;
  };
}
