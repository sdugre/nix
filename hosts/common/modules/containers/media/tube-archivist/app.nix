{ TUBEARCHIVIST_CREDS, TUBEARCHIVIST_ELASTIC_CREDS }:
{ 
  image = "docker.io/bbilly1/tubearchivist";

  environment = {
    UMASK                = "002";
    TZ                   = "America/New_York";
    ES_URL               = http://archivist-es:9200     # needs protocol e.g. http and port
    REDIS_HOST           = archivist-redis              # don't add protocol
    HOST_UID             = "1000";
    HOST_GID             = "986";
    TA_HOST              = tubearchivist.local          # set your host name
  };

  environmentFiles = [ 
    TUBEARCHIVIST_CREDS 
    TUBEARCHIVIST_ELASTIC_CREDS
  ]

  volumes = [
    "/var/lib/containers/media/tube-archivist/cache:/cache"
    "/mnt/data/media/videos-youtube:/youtube"
  ];

  ports = [
    "8050:8000"
  ];

  dependsOn = [
    "tube-archivist-es"
    "tube-archivist-redis"
  ];

  extraOptions = [
    "--network=ta-net"
  ];

  autoStart = true;

}
