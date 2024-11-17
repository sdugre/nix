{
  system.activationScripts = {
    script.text = ''
      install -d -m 755 /var/lib/containers/frigate  -o root -g root
    '';
  };

  virtualisation.oci-containers.containers = {
    frigate = {
      image = "ghcr.io/blakeblackshear/frigate:stable";
      autoStart = true;
      volumes = [
        "/mnt/video/Surveillance:/media/frigate"
        "/var/lib/frigate:/config"
        "/etc/localtime:/etc/localtime:ro"
      ];
      ports = [
        "5000:5000"
        "1935:1935"
      ];
      environment = {
        FRIGATE_RTSP_PASSWORD = "password";
      };
      extraOptions = [
        "--mount=type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000"
        "--device=/dev/bus/usb:/dev/bus/usb"
        "--device=/dev/dri/renderD128"
        "--shm-size=64m"
      ];
    };
  };
}
