{
  lib,
  pkgs,
  config,
  ...
}: {

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "br0";
  };
  
  containers.webserver = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.1.240";
    localAddress = "192.168.1.241";
    config = { config, pkgs, lib, ... }: {
  
      environment.etc = {
        "var/www/html/index.html" = {
          text = ''<html><body><h1>Hello from inside container</h1></body></html>'';
          mode = "0644";
        };
      };

      services.nginx = {
        enable = true;
        virtualHosts."_" = {
          default = true;
          listen = [
            {
            addr = "0.0.0.0";
            port = 80;
            }
          ];
          root = "/etc/var/www/html";
          locations."/" = {
            index = "index.html";
          };
        };
      };
  
      networking = {
        firewall.allowedTCPPorts = [ 80 ];
  
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };
      
      services.resolved.enable = true;
  
      system.stateVersion = "24.11";
    };
  };

}
