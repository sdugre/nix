{
  config,
  pkgs,
  hostname,
  username,
  environment,
  programs,
  ...
}: {
  sops.secrets."msmtp/gmail_token" = {
    sopsFile = ../../${hostname}/secrets.yaml;
    owner = "${username}";
    group = "users";
  };

  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        aliases = "/etc/aliases";
        auth = true;
        from = "sdugre@gmail.com";
        host = "smtp.gmail.com";
        passwordeval = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."msmtp/gmail_token".path}";
        port = 587;
        tls = true;
        tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
        user = "sdugre@gmail.com";
      };
    };
  };

  environment.etc = {
    "aliases" = {
      text = ''
        root: sdugre@gmail.com
        default: sdugre@gmail.com
      '';
      mode = "0644";
    };
  };
}
