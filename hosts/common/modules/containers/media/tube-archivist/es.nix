{TUBEARCHIVIST_ELASTIC_CREDS}: {
  image = "docker.io/bbilly1/tubearchivist-es";

  environment = {
    UMASK = "002";
    TZ = "America/New_York";
    ES_JAVA_OPTS = "-Xms1g -Xmx1g";
    "xpack.security.enabled" = true;
    "discovery.type" = "single-node";
    "path.repo" = "/usr/share/elasticsearch/data/snapshot";
  };

  ulimits = {
    memlock = {
      soft = -1;
      hard = -1;
    };
  };

  environmentFiles = [TUBEARCHIVIST_ELASTIC_CREDS];

  volumes = [
    "/var/lib/containers/media/tube-archivist/es:/usr/share/elasticsearch/data"
  ];

  ports = [
    "9200:9200"
  ];

  extraOptions = [
    "--network=ta-net"
  ];

  autoStart = true;
}
