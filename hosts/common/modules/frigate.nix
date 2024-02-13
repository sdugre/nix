{ config, lib, ... }: {

  networking.firewall.allowedTCPPorts = [ 5000 5001 5002 8082 8554 1984 ];

  services.frigate = {
    enable = true;
    hostname = "nvr2.seandugre.com";
    settings = {
#      mqtt = {
#        enabled = false;
#        host = "http://192.168.1.16";
#      };
      cameras = {
        driveway = {
          ffmpeg.inputs = [
            {
              path = "rtmp://192.168.1.42/bcs/channel0_sub.bcs?channel=0&stream=0&user=admin&password=";
              roles = [ "detect" ];
            }
          ];
#          ffmpeg.input_args = "preset-rtmp-generic";          
          detect = {
            enabled = false;
          };
        };
      };
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/frigate" 
    ];
  };

}
