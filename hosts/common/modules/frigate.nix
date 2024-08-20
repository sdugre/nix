{ config, lib, ... }: {

  networking.firewall.allowedTCPPorts = [ 5000 5001 5002 8082 8554 1984 ];

  services.frigate = {
    enable = true;
    hostname = "nvr2.seandugre.com";
    settings = {

auth:
  enabled: false

detectors:
  coral:
    type: edgetpu
    device: usb

go2rtc:
  streams:
    driveway:
      - "ffmpeg:http://192.168.1.42/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=admin&password="
    driveway_sub:
      - "ffmpeg:http://192.168.1.42/flv?port=1935&app=bcs&stream=channel0_ext.bcs&user=admin&password="

cameras:
  driveway:
    ffmpeg:
      inputs:
        - path: rtsp://127.0.0.1:8554/driveway
          input_args: preset-rtsp-restream
          roles:
            - record
        - path: rtsp://127.0.0.1:8554/driveway_sub
          input_args: preset-rtsp-restream
          roles:
            - detect
    detect:
      height: 480
      width: 640
      fps: 7
    motion:
      mask: 4,155,0,5,639,3,639,311,469,253,448,242,435,222,435,203,433,191,144,170,134,126,76,117,62,158
    snapshots:
      enabled: True
      timestamp: True
      bounding_box: True
    objects:
      track:
        - person
        - car
      filters:
        person:
          min_area: 2000
    record:
      enabled: True
      retain:
        days: 3
        mode: motion
      events:
        retain:
          default: 14
          mode: active_objects

mqtt:
  enabled: false

version: 0.14


#      mqtt = {
#        enabled = false;
#        host = "http://192.168.1.16";
#      };
      cameras = {
#        driveway = {
#          ffmpeg.inputs = [
#            {
#              path = "rtmp://192.168.1.42/bcs/channel0_sub.bcs?channel=0&stream=0&user=admin&password=";
#              roles = [ "detect" ];
#            }
#          ];
#          ffmpeg.input_args = "preset-rtmp-generic";          
#          detect = {
#            enabled = false;
 #         };
  #      };
      };
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/frigate" 
    ];
  };

}
