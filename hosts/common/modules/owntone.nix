{ lib, 
  pkgs, 
  config,
  ... 
}: let
    domain = "seandugre.com";
in {
  imports = [ ../../../modules/nixos/owntone.nix ];
  services.owntone = {
    enable = true;
    group = "media";
    openFirewall = true;
    musicDirectories = [
      "/mnt/data/media/music" 
    ];
    logLevel = "info";
    extraConfig = ''
      rcp "SoundBridge" {
        exclude = false
        clear_on_close = true
      }
    '';
  };

  services.nginx.virtualHosts."owntown.${domain}" = {
    useACMEHost = "${domain}";
    forceSSL = true;
    enableAuthelia = false;
    extraConfig = ''
    '';
    locations."/" = {
      proxyPass = "http://192.168.1.200:${toString config.services.owntone.listenPort}";
      proxyWebsockets = true;
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "${config.services.owntone.cacheDir}"
    ];
  };
}
