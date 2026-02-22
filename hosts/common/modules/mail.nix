{
  config,
  pkgs,
  hostname,
  username,
  environment,
  programs,
  ...
}: 
  let 
    sops_config = { 
      sopsFile = ../../${hostname}/secrets.yaml;
      mode = "0400";
      owner = config.users.users.smtpd.name;
      group = config.users.users.smtpd.group;
      restartUnits = [ "opensmtpd.service" ];
    }; 
  in 
{
  users.groups.mail = {};

  sops.secrets."msmtp/gmail_token" = {
    sopsFile = ../../${hostname}/secrets.yaml;
    owner = "${username}";
    group = "mail";
    mode = "0440";
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

  environment.systemPackages = with pkgs; [
    mailutils
  ];

  sops.secrets."opensmtpd/gmail_token" = sops_config;
  sops.secrets."opensmtpd/clients" = sops_config;

  services.opensmtpd = {
    enable = true;
    setSendmail = false;
    serverConfiguration = ''
      listen on 0.0.0.0
      table secrets file:${config.sops.secrets."opensmtpd/gmail_token".path}
      table allowed_clients file:${config.sops.secrets."opensmtpd/clients".path}
      action "relay" relay host smtp+tls://gmailcreds@smtp.gmail.com:587 auth <secrets> # mail-from "sdugre@gmail.com"
      match from src <allowed_clients> for any action "relay"
    '';
  };

  networking.firewall.allowedTCPPorts = [ 25 ];  
}
