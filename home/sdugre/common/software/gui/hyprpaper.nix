{
  config,
  lib,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ config.wallpaper ];
      wallpaper = [ ",${config.wallpaper}" ];
    };
  };
}

