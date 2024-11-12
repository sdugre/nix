{ config, lib, hostname,... }:{

  networking.firewall.allowedTCPPorts = [ 8783 ];

  services = {
    stirling-pdf = {
      enable = true;
      environment = {
        SERVER_PORT = 8783;
        SECURITY_ENABLE_LOGIN = "true";
        INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "true";
      };
    };
  };

  environment.persistence = lib.mkIf config.services.persistence.enable {
    "/persist".directories = [ 
      "/var/lib/private/stirling-pdf" 
    ];
  };

}
