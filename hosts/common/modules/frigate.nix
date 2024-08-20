{ config, lib, ... }: {

  networking.firewall.allowedTCPPorts = [ 5000 8554 8555 8971 1935 ];
  networking.firewall.allowedUDPPorts = [ 8555 ];

  services.frigate = {
    enable = true;
    hostname = "nvr2.seandugre.com";
    settings = {

      auth = {
        enabled = false;
      };

      detectors.coral = {
        type = "edgetpu";
        device = "usb";
      };

      go2rtc.streams = {
          driveway = "ffmpeg:http://192.168.1.42/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=admin&password=";
          driveway_sub = "ffmpeg:http://192.168.1.42/flv?port=1935&app=bcs&stream=channel0_ext.bcs&user=admin&password=";
      };

      cameras = {
        driveway = {
          ffmpeg = {
            inputs = [
              {
                path = "rtsp://127.0.0.1:8554/driveway";
                input_args = "preset-rtsp-restream";
                roles = [ "record" ];
              },
              {
                path = "rtsp://127.0.0.1:8554/driveway_sub";
                input_args = "preset-rtsp-restream";
                roles = [ "detect" ];
              }
            ];
          };

          detect = {
            height = 480;
            width = 640;
            fps = 7;
          };

          motion.mask = "4,155,0,5,639,3,639,311,469,253,448,242,435,222,435,203,433,191,144,170,134,126,76,117,62,158";
          snapshots = {
            enabled = true;
            timestamp = true;
            bounding_box = true;
          };

          objects = {
            track = [ "person" "car" "dog" ];
            filters.person.min_area = 2000;
          };

          record = {
            enabled = true;
            retain.days = 3;
            retain.mode = "motion";
            events.retain.default = 14;
            events.retain.mode = "active_objects";
          };
        };  
      };          

      mqtt.enabled = false;

      version: 0.14
   
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/frigate" 
    ];
  };

}
