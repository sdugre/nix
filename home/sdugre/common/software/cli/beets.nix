{ pkgs, username, ... }:
{
  programs.beets = {
    enable = true;
    settings = {
      directory = "/mnt/music";
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
      ";

      import = {
        move = true;
        log = "/home/${username}/.config/beets/beetslog.txt";
      };

      original_date = true;
      fetchart = {
        auto = "yes";
        sources = "filesystem coverart lastfm itunes amazon wikipedia";
        lastfm_key = "8bfcb4bcf5e51bcab3ecef70d981b91e";
      };

      plex = {
        host = "192.168.1.66";
        port = "32400";
        token = "6zVJ3DgUcv1JBMyTKTKx";
      };

      discogs = {
        user_token = "IetwGGqEhVSxAkQdkDezNbxcyemntwsvazuTAWlI";
      }; 

      paths = {
        default = "%the{$albumartist}/[$original_year] $album/$track - $title";
        comp = "_Compilations/[$original_year] $album/$track - $albumartist - $title";
        "albumtype:live" = "%the{$albumartist}/$atypes[$year] $album/$track - $title";
        "albumtype:ep" = "%the{$albumartist}/[$original_year]$atypes $album/$track - $title";
      };

      subsonic = {
        url = "https://music.seandugre.com";
        user = "admin";
        pass = "admin";
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
    };
  };
}
