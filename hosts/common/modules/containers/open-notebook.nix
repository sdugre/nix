{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {

  sops.secrets."open-notebook-env" = {
    sopsFile = ../../../${hostname}/secrets.yaml;
  };

  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/open-notebook -o root -g root
      install -d -m 755 /var/lib/containers/open-notebook/notebook_data -o root -g root
      install -d -m 755 /var/lib/containers/open-notebook/surreal_data -o root -g root
    '';
  };

  virtualisation.oci-containers.containers = {
    open-notebook = {
      image = "lfnovo/open_notebook:v1-latest-single";
      environmentFiles = [ config.sops.secrets.open-notebook-env.path ];
      volumes = [
        "/var/lib/containers/open-notebook/notebook_data:/app/data"
        "/var/lib/containers/open-notebook/surreal_data:/mydata"
      ];
      ports = [
        "8502:8502"
        "5055:5055"
      ];
      autoStart = true;
    };
  };

  services.nginx.virtualHosts."ai.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:8502";
      proxyWebsockets = true;
    };
  };

}


