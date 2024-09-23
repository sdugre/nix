{ config, lib, pkgs, ... }:
{
  # Enable NAT
  networking.nat = {
    enable = true;
    externalInterface = "eth0";
    internalInterfaces = [ "wg0" ];
  };
  # Open ports in the firewall
  networking.firewall = {
    allowedTCPPorts = [ 54 ];
    allowedUDPPorts = [ 54 51821 ];
  };

  networking.wg-quick.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP/IPv6 address and subnet of the client's end of the tunnel interface
      address = [ "10.10.10.1/24" ];
      # The port that WireGuard listens to - recommended that this be changed from default
      listenPort = 51821;
      # Path to the server's private key
      privateKeyFile = "/root/wireguard-keys/privatekey";

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.10.10.1/24 -o eth0 -j MASQUERADE
      '';

      # Undo the above
      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.10.10.1/24 -o eth0 -j MASQUERADE
      '';

      peers = [
        { # phone
          publicKey = "zG8ScoRB/uSKRGqmX1ivBhy4UF8JyiL/TqMcllVSFgQ=";
#          presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0_key";
          allowedIPs = [ "10.10.10.2/32" ];
        }
      ];
    };
  };

  services = {
    dnsmasq = {
      enable = true;
      extraConfig = ''
        interface=wg0
        port=54
      '';
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/root/wireguard-keys"
    ];
  };
}
