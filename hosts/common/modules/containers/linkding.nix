{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {

  sops.secrets."linkding-env" = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

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
      environmentFiles = [ config.sops.secrets.linkding-env.path ];
      volumes = [
        "/var/lib/containers/linkding:/etc/linkding/data"
      ];
      ports = [
        "9090:9090"
      ];
      autoStart = true;
    };
  };
}
