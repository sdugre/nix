{ lib, pkgs, config, ... }:
let 
  port = 8087;
in
{  

  services.miniflux = {
    enable = true;
    config = {
      PORT = toString port;
    };
    # Set initial admin user/password
    adminCredentialsFile = pkgs.writeText "cred" ''
      ADMIN_USERNAME=miniflux
      ADMIN_PASSWORD=miniflux
    '';
  };

  networking.firewall.allowedTCPPorts = [ port ];
  networking.firewall.allowedUDPPorts = [ port ];

}
