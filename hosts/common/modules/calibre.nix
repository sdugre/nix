{ lib, pkgs,config, ...}: 
let
  library = "/var/lib/calibre-lib";
in 
{
  services = {
    calibre-server = {
      enable = false;  # use content server from calibre podman container instead
      group = "media";
      libraries = [library];
    };
    calibre-web = {
      enable = true;
      group = "media";
      listen.ip = "0.0.0.0";
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
        calibreLibrary = library;
      };
    };
  };

  systemd.services.calibre-lib.serviceConfig = {
    User = "calibre-server";
    Group = "media";
    StateDirectory = "calibre-lib";
    StateDirectoryMode = "0755";
  };

  systemd.services.calibre-server.serviceConfig.ExecStart = lib.mkForce "${pkgs.calibre}/bin/calibre-server ${library}";
  networking.firewall.allowedTCPPorts = [ 8083 ];

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/calibre-server"
      "/var/lib/calibre-web"
      library
    ];
  };

}
