{
  image = "docker.io/redis/redis-stack-server:latest";

  environment = {
    UMASK = "002";
    TZ = "America/New_York";
  };

  volumes = [
    "/var/lib/containers/media/tube-archivist/redis:/data"
  ];

  ports = [
    "6379:6379"
  ];

  extraOptions = [
    "--network=ta-net"
  ];

  dependsOn = [
    "tube-archivist-es"
  ];

  autoStart = true;
}
