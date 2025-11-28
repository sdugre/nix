{
  pkgs,
  config,
  hostname,
  ...
}: {

  sops.secrets = {
    "cloudflare-tunnel" = {
      sopsFile = ../../${hostname}/secrets.yaml;
    };

    "cloudflare-cert" = {
      sopsFile = ../../${hostname}/secrets.yaml;
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "chummie" = {
        credentialsFile = config.sops.secrets."cloudflare-tunnel".path;
        certificateFile = config.sops.secrets."cloudflare-cert".path;
        # forward all requests to local nginx proxy
        default = "https://127.0.0.1:443";
        # this line needed to prevent redirect loop.  nginx handles tls
        originRequest.noTLSVerify = true;
      };
    };

  };
}


# inspriration: https://www.youtube.com/watch?v=c5Hx4osU5A8
# to setup the tunnel:
# nix shell -p cloudflared
# cloudflared tunnel login
# cloudflared tunnel create chummie
# cloudflared tunnel route dns [tunnel ID] *.seandugre.com
# use the cert.pem and credentials json created at ~/.cloudflared/ in sops
