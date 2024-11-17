{
  image = "ghcr.io/recyclarr/recyclarr";

  environment = {
    TZ = "America/New_York";
    RECYCLARR_CREATE_CONFIG = "true";
  };

  extraOptions = [
    "--user=1000:986"
  ];

  volumes = [
    "/var/lib/containers/media/recyclarr:/config"
  ];

  ports = [
  ];

  autoStart = true;
}
