{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/linkding -o root -g root
    '';
  };

  virtualisation.oci-containers.containers = {
    linkding = {
      image = "sissbruecker/linkding:latest";
      environment = {
        TZ = "America/New_York";
      };
      volumes = [
        "/var/lib/containers/linkding:/etc/linkding/data"
        "/mnt/data/media:/data"
      ];
      ports = [
        "9090:9090"
      ];
      autoStart = true;
    };
  };
}
