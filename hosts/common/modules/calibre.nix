{ lib, pkgs,config, ...}: 
let
  library = "/var/lib/calibre-server";
in 
{
  services = {
    calibre-server = {
      enable = true;
      group = "media";
      libraries = [library];
    };
    calibre-web = {
      enable = false;
      group = "media";
      listen.ip = "0.0.0.0";
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
        calibreLibrary = library;
      };
    };
  };


  systemd.services.calibre-server.serviceConfig.ExecStart = lib.mkForce "${pkgs.calibre}/bin/calibre-server ${library}";
  networking.firewall.allowedTCPPorts = [ 8080 8081 8083 ];

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/calibre-server"
      "/var/lib/calibre-web"
    ];
  };

}
