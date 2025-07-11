{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {

  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/bibliotheca -o root -g root
    '';
  };

  virtualisation.oci-containers.containers = {
    bibliotheca = {
      image = "pickles4evaaaa/mybibliotheca:latest";
      environment = {
        TZ = "America/New_York";
        WORKERS = "6";
      };
      volumes = [
        "/var/lib/containers/bibliotheca:/app/data"
      ];
      ports = [
        "5054:5054"
      ];
      autoStart = true;
    };
  };
  
  networking.firewall.allowedTCPPorts = [5054];
}
