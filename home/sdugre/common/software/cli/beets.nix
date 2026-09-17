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
        zero
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
        default = "%the{$albumartist}/[$original_year] $album%aunique{}/$disc_and_track - $title";
        comp = "_Compilations/[$original_year] $album/$disc_and_track - $artist - $title";
        "albumtype:live" = "%the{$albumartist}/$atypes[$year] $album/$disc_and_track - $title";
        "albumtype:ep" = "%the{$albumartist}/[$original_year]$atypes $album/$disc_and_track - $title";
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

      zero = {
        auto = true;
        update_database = true;
        fields = [
          "mb_albumartistid"
          "mb_albumartistids" 
          "mb_albumid" 
          "mb_artistid" 
          "mb_artistids" 
          "mb_releasegroupid"
          "mb_releasetrackid"
          "mb_trackid" 
          "mb_workid"
          "comments"
        ];
        mb_albumartistid =  ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
        mb_albumartistids = ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
        mb_albumid =        ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
        mb_artistid =       ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
        mb_artistids =      ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
        mb_releasegroupid = ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
        mb_releasetrackid = ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
        mb_trackid =        ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
        mb_workid =         ["^(?![0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}).*$"];
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
