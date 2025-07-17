{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {

  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/jelu -o root -g root
      install -d -m 755 /var/lib/containers/jelu/config -o root -g root
      install -d -m 755 /var/lib/containers/jelu/database -o root -g root
      install -d -m 755 /var/lib/containers/jelu/files/images -o root -g root
      install -d -m 755 /var/lib/containers/jelu/files/imports -o root -g root
    '';
  };

  virtualisation.oci-containers.containers = {
    jelu = {
      image = "wabayang/jelu";
      environment = {
        TZ = "America/New_York";
        JELU_METADATA_CALIBRE_PATH = "/usr/bin/fetch-ebook-metadata";
      };
      volumes = [
        "/var/lib/containers/jelu/config:/config"
        "/var/lib/containers/jelu/database:/database"
        "/var/lib/containers/jelu/files/images:/files/images"
        "/var/lib/containers/jelu/files/imports:/files/imports"
      ];
      ports = [
        "11111:11111"
      ];
      autoStart = true;
    };
  };
  
  networking.firewall.allowedTCPPorts = [11111];

  services.nginx.virtualHosts."books.seandugre.com" = {
    useACMEHost = "seandugre.com";
    forceSSL = true;
    enableAuthelia = true;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:11111";
      proxyWebsockets = true;
    };
  };
}
