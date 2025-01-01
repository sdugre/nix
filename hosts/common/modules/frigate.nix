{
  config,
  lib,
  hostname,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [5000 5001 5002 8082 8554 8555 8971 1935 1984];
  networking.firewall.allowedUDPPorts = [8555];

  services.go2rtc.enable = true;
  services.go2rtc.settings.streams = {
    driveway = ["ffmpeg:http://192.168.1.42/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=admin&password="];
    driveway_sub = ["ffmpeg:http://192.168.1.42/flv?port=1935&app=bcs&stream=channel0_ext.bcs&user=admin&password="];
    porch = ["ffmpeg:http://192.168.1.40:8081/videostream.cgi?user=sdugre&pwd=\${FRIGATE_RTSP_PASSWORD}#video=h264#hardware"];
  };

  # hardware encode/decode with amdgpu vaapi
  systemd.services.frigate = {
    environment.LIBVA_DRIVER_NAME = "i965";
    serviceConfig = {
      SupplementaryGroups = ["render" "video"]; # for access to dev/dri/*
      AmbientCapabilities = "CAP_PERFMON";
    };
  };

  services.frigate = {
    enable = true;
    hostname = "nvr.seandugre.com";
    vaapiDriver = "i965";
    settings = {
      auth.enabled = false;
      tls.enabled = false;

      #      ffmpeg = { hwaccel_args = "preset-vaapi"; };

      detectors.coral = {
        type = "edgetpu";
        device = "usb";
      };

      go2rtc.streams = {
        rtsp = {
          listen = ":8554";
        };
        driveway = ["ffmpeg:http://192.168.1.42/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=admin&password="];
        driveway_sub = ["ffmpeg:http://192.168.1.42/flv?port=1935&app=bcs&stream=channel0_ext.bcs&user=admin&password="];
        porch = ["ffmpeg:http://192.168.1.40:8081/videostream.cgi?user=sdugre&pwd={FRIGATE_RTSP_PASSWORD}#video=h264#hardware"];
      };

      go2rtc.webrtc = {
        candidates = [
          "192.168.1.200:8555"
          "${config.services.frigate.hostname}:8555"
          "stun:8555"
        ];
      };

      record = {
        enabled = true;
        retain.days = 3;
        retain.mode = "motion";
        events.retain.default = 14;
        events.retain.mode = "active_objects";
      };

      snapshots = {
        enabled = true;
        timestamp = true;
        bounding_box = true;
      };

      cameras = {
        porch = {
          ffmpeg = {
            inputs = [
              {
                path = "rtsp://127.0.0.1:8554/porch";
                input_args = "preset-rtsp-restream";
                roles = ["record" "detect"];
              }
            ];
          };
          detect = {
            height = 480;
            width = 640;
            fps = 7;
          };
          objects = {
            track = ["person"];
            filters.person.min_area = 2000;
          };
        };

        driveway = {
          ffmpeg = {
            inputs = [
              {
                path = "rtsp://127.0.0.1:8554/driveway";
                input_args = "preset-rtsp-restream";
                roles = ["record"];
              }
              {
                path = "rtsp://127.0.0.1:8554/driveway_sub";
                input_args = "preset-rtsp-restream";
                roles = ["detect"];
              }
            ];
          };

          detect = {
            height = 480;
            width = 640;
            fps = 7;
          };

          motion.mask = [
            "4,155,0,5,639,3,639,311,469,253,448,242,435,222,435,203,433,191,144,170,134,126,76,117,62,158"
            "0.592,0.929,0.635,0.932,0.636,0.966,0.595,0.969" # timestamp
          ];

          objects = {
            track = ["person" "car" "dog"];
            filters.person.min_area = 2000;
          };

          zones = {
            walkway = {
              coordinates = ["0.034,0.456,0.077,0.374,0.18,0.377,0.277,0.469,0.389,0.653,0.089,0.672"];
            };
            inner_driveway = {
              coordinates = ["0.002,0.679,0.901,0.619,1,0.677,0.999,0.998,0.003,0.996"];
            };
          };

          review.alerts.required_zones = ["walkway" "inner_driveway"];
        };
      };

      mqtt = {
        enabled = true;
        host = "192.168.1.201";
        user = "{FRIGATE_MQTT_USER}";
        password = "{FRIGATE_MQTT_PASSWORD}";
      };
      version = "0.14";
    };
  };


  sops.secrets.frigate = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };

  systemd.services.frigate.serviceConfig.EnvironmentFile = config.sops.secrets.frigate.path;
  systemd.services.go2rtc.serviceConfig.EnvironmentFile = config.sops.secrets.frigate.path;

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [
      "/var/lib/frigate"
    ];
  };
}
