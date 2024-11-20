{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:{

  networking.firewall.allowedTCPPorts = [8888];

  sops.secrets.searxng-secret = {
    sopsFile = ../../${hostname}/secrets.yaml;
  };
  services.searx = {
    enable = true;
    redisCreateLocally = true;
    environmentFile = config.sops.secrets.searxng-secret.path;
    limiterSettings = {
      botdetection = {
        ip_lists = {
          pass_ip = [
            "192.168.0.0/16"
            "172.16.0.0/12"
            "10.0.0.0/8"
          ];
        };
      };
    };
    settings = {
      search = {
        safe_search = 0;
        autocomplete = "duckduckgo"; # dbpedia, duckduckgo, google, startpage, swisscows, qwant, wikipedia - leave blank to turn off
        default_lang = ""; # leave blank to detect from browser info or use codes from languages.py
      };

      server = {
        port = 8888;
        bind_address = "0.0.0.0";
        secret_key = "@SEARXNG_SECRET@";
      };
      # Search engines
      engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        "duckduckgo".disabled = false;
        "wikidata".disabled = true;
      };
    };
  };
}
