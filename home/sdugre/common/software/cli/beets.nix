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
  sops.templates."discogs_token".content = ''"${config.sops.placeholder."discogs_token"}"'';

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
        info 
        discogs 
        hook 
        the 
        web 
        subsonicupdate 
        albumtypes 
        permissions
        musicbrainz
        inline
        fromfilename
      ";

      import = {
        move = true;
        log = "/home/${username}/.config/beets/beetslog.txt";
      };

      original_date = true;
      fetchart = {
        auto = "yes";
        sources = ["filesystem" "coverart" "lastfm" "itunes" "amazon" "wikipedia"];
        lastfm_key = config.sops.secrets."lastfm_key".path;
      };

      discogs = {
       # user_token = config.sops.templates."discogs_token".content;
        data_source_mismatch_penalty = 0.3; # prefer disgogs over musicbrainz
      };

      musicbrainz = {
        data_source_mismatch_penalty = 0.5; 
      };

      paths = {
        default = "%the{$albumartist}/[$original_year] $album/$disc_and_track - $title";
        comp = "_Compilations/[$original_year] $album/%if{$multidisc,Disc $disc/}$track - $artist - $title";
        "albumtype:live" = "%the{$albumartist}/$atypes[$year] $album/$track - $title";
        "albumtype:ep" = "%the{$albumartist}/[$original_year]$atypes $album/$track - $title";
      };

      item_fields = {
        multidisc = "1 if disctotal > 1 else 0";
        disc_and_track = "u'%i-%02i' % (disc, track) if disctotal > 1 else u'%02i' % (track)";
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
