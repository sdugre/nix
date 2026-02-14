{
  pkgs,
  username,
  config,
  ...
}: {
  sops.secrets."lastfm_key" = {
    sopsFile = ../../../secrets.yaml;
  };
  sops.secrets."plex_token" = {
    sopsFile = ../../../secrets.yaml;
  };
  sops.secrets."discogs_token" = {
    sopsFile = ../../../secrets.yaml;
  };
  sops.secrets."gonic_password" = {
    sopsFile = ../../../secrets.yaml;
  };

  programs.beets = {
    enable = true;
    settings = {
      directory = "/mnt/data/media/music";
      library = "/home/${username}/.config/beets/library.blb";
      asciify_paths = "yes";
      clutter = [
        "Thumbs.DB"
        ".DS_Store"
        "@eaDir"
      ];
      plugins = "
        edit 
        fetchart 
        plexupdate 
        info 
        discogs 
        hook 
        the 
        web 
        subsonicupdate 
        albumtypes 
        permissions
        musicbrainz
      "; # discogs removed...

      import = {
        move = true;
        log = "/home/${username}/.config/beets/beetslog.txt";
      };

      original_date = true;
      fetchart = {
        auto = "yes";
        sources = "filesystem coverart lastfm itunes amazon wikipedia";
        lastfm_key = config.sops.secrets."lastfm_key".path;
      };

      plex = {
        host = "192.168.1.200";
        port = "32400";
        token = config.sops.secrets."plex_token".path;
      };

#      discogs = {
#        user_token = config.sops.secrets."discogs_token".path;
#      };

      musicbrainz = { };

      paths = {
        default = "%the{$albumartist}/[$original_year] $album/$track - $title";
        comp = "_Compilations/[$original_year] $album/$track - $artist - $title";
        "albumtype:live" = "%the{$albumartist}/$atypes[$year] $album/$track - $title";
        "albumtype:ep" = "%the{$albumartist}/[$original_year]$atypes $album/$track - $title";
      };

      subsonic = {
        url = "https://music.seandugre.com";
        user = "admin";
        pass = config.sops.secrets.gonic_password.path;
        auth = "pass";
      };

      embedart = {
        auto = "no";
      };

      albumtypes = {
        types = [
          {ep = "EP";}
          {single = "Single";}
          {soundtrack = "OST";}
          {live = "Live";}
          {compilation = "Anthology";}
        ];
        ignore_va = "compilation";
        bracket = "[]";
      };

      permissions = {
        file = "644";
        dir = "755";
      };
      
      hook.hooks = [
        {
          event = "album_imported";
          command = "ssh -i /home/sdugre/.ssh/id_ed25519 volumio@192.168.1.32 /usr/bin/mpc update";
        }
      ];
    };
  };
}
